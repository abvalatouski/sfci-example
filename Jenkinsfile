#!groovy

import groovy.json.JsonSlurperClassic

node {
  def SF_CONSUMER_KEY=env.SF_CONSUMER_KEY
  def SF_USERNAME=env.SF_USERNAME
  def SERVER_KEY_CREDENTALS_ID=env.SERVER_KEY_CREDENTALS_ID
  def TEST_LEVEL='RunAllTestsInOrg'
  def SF_INSTANCE_URL = env.SF_INSTANCE_URL ?: "https://login.salesforce.com"

  stage('checkout source') {
    checkout scm
  }

  withCredentials([file(credentialsId: SERVER_KEY_CREDENTALS_ID, variable: 'server_key_file')]) {
    stage('Authorization') {
      rc = command """\
        sfdx auth:jwt:grant\
          --clientid ${SF_CONSUMER_KEY}\
          --instanceurl ${SF_INSTANCE_URL}\
          --jwtkeyfile ${server_key_file}\
          --setdefaultdevhubusername\
          --username ${SF_USERNAME}\
      """
      if (rc != 0) {
        error 'Authorization failed'
      }

      rc = command """\
        sfdx config:set\
          defaultusername=${SF_USERNAME}\
      """
      if (rc != 0) {
        error 'Failed to set default username'
      }
    }

    stage('Test Deployment') {
      rc = command """\
        sfdx force:source:deploy\
          --checkonly\
          --sourcepath .\
          --verbose\
          --testlevel ${TEST_LEVEL}\
      """
      if (rc != 0) {
        error 'Test deployment failed'
      }
    }
  }
}

def command(script) {
  bat(
    returnStatus: true,
    returnStdout: true,
    script: script,
  );
}
