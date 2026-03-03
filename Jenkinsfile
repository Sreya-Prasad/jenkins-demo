pipeline {
  agent any
  options { timestamps() }

  // ---------- Input Parameters ----------
  parameters {
    choice(name: 'ENV', choices: ['dev', 'stage', 'prod'], description: 'Target environment')
    booleanParam(name: 'RUN_TESTS', defaultValue: true, description: 'Run test stage?')
  }

  // ---------- Global Environment ----------
  environment {
    APP_NAME = 'jenkins-demo'
    BUILD_TAG = "${env.JOB_NAME}-${env.BUILD_NUMBER}"
  }

  stages {

//---------------Jenkins Agent or Node--------------------
   stage('Agent Test') {
      steps {
        bat "echo Running on agent: %COMPUTERNAME%"
      }
    }

//------------MUltibranch Pipeline----------------
    stage('Build (dev only)') {
      when { branch 'dev' }
        steps {
            bat 'echo Building DEV branch...'
            bat 'call build.bat'
            }
      }
//--------------Parallel Jobs-----------
    stage('Parallel Jobs') {
  parallel {
    stage('Check A') {
      steps {
        bat """
          echo Running Job A...
          ping -n 3 127.0.0.1 >nul
        """
      }
    }

    stage('Check B') {
      steps {
        bat """
          echo Running Job B...
          ping -n 3 127.0.0.1 >nul
        """
      }
    }

    stage('Check C') {
      steps {
        bat """
          echo Running Job C...
          ping -n 3 127.0.0.1 >nul
        """
      }
    }
  }
}
//-------------Pipeline--------------
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Info') {
      steps {
        echo "🔧 App: ${env.APP_NAME}"
        echo "🌍 Environment: ${params.ENV}"
        echo "🏷️ Build tag: ${env.BUILD_TAG}"
        bat 'echo Current directory: & cd'
      }
    }

    stage('Build') {
      steps {
        bat """
          echo ====== BUILD START (%DATE% %TIME%) ====== > build_log.txt
          echo Building %APP_NAME% for %ENV% >> build_log.txt
          echo Starting Windows build... >> build_log.txt
          call build.bat >> build_log.txt 2>&1
          echo ====== BUILD END (%DATE% %TIME%) ====== >> build_log.txt
        """
      }
    }

    stage('Tests (conditional)') {
      when {
        expression { return params.RUN_TESTS == true }
      }
      steps {
        bat """
          echo Running sample tests... >> test_results.txt
          echo TEST CASE 1: PASS >> test_results.txt
          echo TEST CASE 2: PASS >> test_results.txt
        """
      }
    }

    stage('Package Artifacts') {
      steps {
        bat """
          if exist artifacts rmdir /s /q artifacts
          mkdir artifacts
          copy build_log.txt artifacts\\
          if exist test_results.txt copy test_results.txt artifacts\\
          powershell -Command "Compress-Archive -Path artifacts\\* -DestinationPath artifacts.zip -Force"
        """
      }
    }
  }

  
//--------------------Post-Build Actions---------------
  post {
    success {
      echo '✅ Build pipeline completed successfully.'
      archiveArtifacts artifacts: 'artifacts.zip, artifacts/*', fingerprint: true
    }
    failure {
      echo '❌ Build failed. Check console logs.'
      archiveArtifacts artifacts: 'build_log.txt', fingerprint: true, onlyIfSuccessful: false
    }
    always {
      echo "ℹ️ Build URL: ${env.BUILD_URL}"
    }
  }
}
