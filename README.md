# jenkins-demo
This a Jenkins practice project (GitHub + Jenkins Integration).

##Line‑by‑line explanation of build.bat

###@echo off

What it does: Turns off command echoing for this script.
Why: Without this, every command in the batch file would be printed to the console before executing, cluttering your Jenkins console output.
Note: The leading @ applies “don’t echo” even to this line itself.

###setlocal

What it does: Starts a local environment scope for variables and settings changed in this script (like set VAR=value).
Why: Ensures any environment variable changes inside the script don’t leak out to other Jenkins steps or the agent environment.
Paired with: endlocal, which restores the previous environment.

echo Code pulled successfully
echo Build started...

What they do: Print friendly progress messages to the console so Jenkins logs are readable.
Why: Good observability—when you or your team looks at build logs later, these messages help diagnose where failures happen.

###timeout /t 2 /nobreak >nul 2>&1

What it does: Sleeps for 2 seconds without allowing keypress interruption and silences all output.
Why we used this exact form in Jenkins:

timeout in Windows can try to read keyboard input and/or interact with a console.
Jenkins agents often run as a Windows service (e.g., LocalSystem) without an interactive console, which causes this error:
ERROR: Input redirection is not supported, exiting the process immediately.

/nobreak prevents timeout from checking for any key presses.
>nul discards normal output (stdout).
2>&1 also discards error output (stderr) by redirecting it to the same place as stdout (which is already going to nul).

Net effect: A clean, quiet, reliable delay that works in non-interactive Jenkins service contexts.

✅ If timeout still misbehaves in your environment, the fallback is:
ping -n 3 127.0.0.1 >nul
which approximates ~2 seconds (ping sends 2 waits between 3 pings).

###echo Build completed!

What it does: Final message to indicate successful flow.
Why: Clear, human-readable signal in logs that your build step reached the end as expected.

###endlocal

What it does: Ends the local environment scope started by setlocal.
Why: Restores original environment variables so Jenkins (and subsequent steps) aren’t affected by your script.

###exit /b 0

What it does: Exits the current batch context (the script) and returns exit code 0.
Why: Jenkins uses the process exit code to determine build success/failure:

0 = SUCCESS
non‑zero = FAILURE

Why /b: Exits the batch file instead of closing the entire cmd.exe session that Jenkins started. This is good hygiene when Jenkins chains multiple commands.
