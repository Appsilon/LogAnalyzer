# LogAnalyzer

The LogAnalyzer app uses the Posit Connect API to fetch logs for application run jobs, semantically colouring them so they are easier to read.

This was originally developed at Elkem, which made us realise that this is a pretty general purpose app which can be used by anyone.

The only thing you need to set this up and use is the `CONNECT_API_KEY` set as an environment variable.

The API key owner should have Admin-level privileges. Else, the app may not be able to fetch jobs and logs.
