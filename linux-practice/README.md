
# Bash Deployment Configuration Validation

## Objective
Validate an application's environment configuration before deployment.

## Files
- `app.conf` — Sample application configuration.
- `validate.sh` — Bash script that validates the configuration.

## How It Works
The script checks whether `app.conf` contains the exact line `APP_ENV=production`.

- Valid configuration: Displays PASSED and exits with code 0.
- Invalid configuration: Displays FAILED and exits with code 1.

## Run the Validation
```bash
bash validate.sh
echo $?
```

## Testing
Both scenarios were tested successfully:

1. `APP_ENV=development` — Validation FAILED (exit 1).
2. `APP_ENV=production` — Validation PASSED (exit 0).

## Skills Demonstrated
Bash scripting, grep, conditional statements, exit codes, configuration validation and troubleshooting.
