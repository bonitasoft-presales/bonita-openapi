@Library('github.com/bonitasoft-presales/bonita-jenkins-library@1.0.1') _

//def bonitaVersion = "7.14.0"
def bonitaVersionShortened = "7140"
def nodeName = "bcd-${bonitaVersionShortened}"

node("${nodeName}") {

    //def scenarioFile = "/home/bonita/bonita-continuous-delivery/scenarios/scenario-ec2.yml"
    //def bonitaConfiguration = "Qualification"

    // used to archive artifacts
    def jobBaseName = "${env.JOB_NAME}".split('/').last()

    // used to set build description and bcd_stack_id
    def gitRepoName = "${env.JOB_NAME}".split('/')[1]
    def normalizedGitRepoName = gitRepoName.toLowerCase().replaceAll('-','_')

    // used to set bcd_stack_id
    def branchName = env.BRANCH_NAME
    def normalizedBranchName = branchName.toLowerCase().replaceAll('-','_')

    //bcd_stack_id overrides scenario value
    //will deploy all PR on same server
    def stackName = "${normalizedGitRepoName}_${normalizedBranchName}_${bonitaVersionShortened}"

    // set to true/false if bonitaConfiguration requires a .bconf file
    // e.g. configuration has parameters
    //def useBConf = false

    // set to true/false to switch verbose and debug mode
    def debugMode = false

    def debug_flag = ''
    def verbose_mode= ''
    if ("${debugMode}".toBoolean()) {
        debug_flag = '-X'
        verbose_mode='-v'
    }

    // used in steps, do not change
    def yamlFile = "${WORKSPACE}/props.yaml"
    //def bconfFolder = '/home/bonita/bonita-continuous-delivery/bconf'
    def yamlStackProps
    def privateDnsName
    def privateIpAddress
    def publicDnsName
    def publicIpAddress
    def bonitaAwsVersion = '1.0-SNAPSHOT'
    def keyFileName = '~/.ssh/presale-ci-eu-west-1.pem'

    //def extraVars="${verbose_mode} --extra-vars bcd_stack_id=${stackName} --extra-vars bonita_version=${bonitaVersion}"

    ansiColor('xterm') {
        timestamps {

            stage("Checkout") {
                checkout scm
                echo "jobBaseName: $jobBaseName"
                echo "gitRepoName: $gitRepoName"
            }

             stage("Create stack") {
                sh """
cd ~/ansible/aws
java -jar bonita-aws-${bonitaAwsVersion}-jar-with-dependencies.jar -c create --stack-id ${stackName} --name ${normalizedGitRepoName} --key-file ${keyFileName}
cp ${stackName}.yaml ${WORKSPACE}
"""
                yamlStackProps = readYaml file: "${WORKSPACE}/${stackName}.yaml"
                privateDnsName = yamlStackProps.privateDnsName
                privateIpAddress = yamlStackProps.privateIpAddress
                publicDnsName = yamlStackProps.publicDnsName
                publicIpAddress = yamlStackProps.publicIpAddress
                echo "privateDnsName: [${privateDnsName}]"
                echo "privateIpAddress: [${privateIpAddress}]"
                echo "publicDnsName: [${publicDnsName}]"
                echo "publicIpAddress: [${publicIpAddress}]"
            }

            stage("clean SSH known hosts records"){
                // ensure private ip/dns name is removed from known hosts since AWS reuse IPs
                // keep this stage after build, to ensure SSHd is up & running on created stack
                sh """
ssh-keygen -R ${privateDnsName}
ssh-keygen -R ${privateIpAddress}
ssh -o StrictHostKeyChecking=no -i ~/.ssh/presale-ci-eu-west-1.pem  ubuntu@${privateDnsName} ls
ssh -o StrictHostKeyChecking=no -i ~/.ssh/presale-ci-eu-west-1.pem  ubuntu@${privateIpAddress} ls
"""
            }

            stage("Deploy docker containers ") {
                sh """
cd ${WORKSPACE}/ansible
ansible-playbook ansible_scenario.yaml -i aws/private-inventory-${stackName}.yaml
"""
                // FIXME
                def bonitaUrl = "http://${publicDnsName}:8081/bonita/login.jsp"
                currentBuild.description = "<a href='${bonitaUrl}'>${stackName}</a>"
            }

            stage('Create yml parameter file') {
                echo "yamlFile set to set server URL: ${yamlFile}"
                if( fileExists(yamlFile)) {
                    echo "remove existing file ${yamlFile}"
                    sh "rm $yamlFile"
                }
                def yamlProps = [:]
                yamlProps.global_parameters=[ [ name:'serverUrl',type:'String',value:"http://${yamlStackProps.publicDnsName}:8081/bonita"]]
                writeYaml file:yamlFile, data:yamlProps
            }




        } // timestamps
    } // ansiColor
} // node