#!groovy

import groovy.json.JsonSlurperClassic

node {
  stage('Checkout to HEAD') {
    checkout(scm);
  }

  withCredentials([file(
    credentialsId: env.SERVER_KEY_CREDENTALS_ID,
    variable: 'JWT_KEY_FILE',
  )]) {
    state('Authorization') {
      execute(
        command: """
          sfdx auth:jwt:grant\
            --clientid ${env.SF_CONSUMER_KEY}\
            --instanceurl ${env.SF_INSTANCE_URL}\
            --jwtkeyfile ${JWT_KEY_FILE}\
            --setdefaultdevhubusername\
            --username ${env.SF_USERNAME}\
        """,
        errorMessage: 'Authorization failed',
      );

      execute(
        command: """
          sfdx config:set\
            defaultusername=${env.SF_USERNAME}\
        """,
        errorMessage: 'Failed to set default username',
      );
    }
  }

  stage('Test Deployment') {
    execute(
      command: """
        sfdx force:source:deploy\
          --checkonly\
          --sourcepath .\
          --verbose\
          --testlevel ${env.SF_TEST_LEVEL}\
      """,
      errorMessage: 'Test deployment failed',
    );
  }
}

def execute(command, errorMessage) {
  def exitCode = bat(
    returnStatus: true,
    returnStdout: true,
    script: command,
  );
  if (exitCode != 0) {
    error(errorMessage);
  }
}
