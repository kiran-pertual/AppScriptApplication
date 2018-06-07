# App script Executable
This project will hit the app script executable which will copy the original spreadsheet in a specific folder with a name provided in a payload.
This would also override some cell values and applies trigger on it. It would add a Menu to hit the post request with payload collected from current copied spreadsheet.

## Steps for App Script Run

1. Run rake file using 'rake clone_spreadsheet:run'
2. For the first time it will ask the user to paste the URL in browser. This will generate a token. Copy the token and paste it on console.
3. It will save the access token and refresh token in the `tokens.yml` file.

Note : From the second execution, It would read the access token from tokens.yml. Access token would get expired in an hour, it would generate new access token from saved refresh token.
