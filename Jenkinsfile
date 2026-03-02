pipeline {
  agent any
  options { timestamps() }
  // For webhook builds, leave triggers empty here and check the webhook box in job UI
  // For polling fallback, uncomment:
  // triggers { pollSCM('H/1 * * * *') }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }
    stage('Build') {
      steps {
        bat """
          echo Starting Windows build...
          call build.bat
        """
      }
    }
  }

  post {
    success {
      echo 'Build pipeline completed successfully.'
      archiveArtifacts artifacts: 'build.bat', fingerprint: true
    }
    failure {
      echo 'Build failed. Check console logs.'
    }
  }
}
