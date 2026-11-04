 #!/bin/bash
echo "Starting deployment configuration validation..."
 
 if grep -Fxq "APP_ENV=production" app.conf; then
	 echo "Deployment validation PASSED"
	 exit 0
else
	echo "Deployment validation FAILED"
	exit 1
fi
