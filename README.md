# LogAnalyzer

The LogAnalyzer open-source app is a simple, plug and play application developed first in collaboration with [Elkem](https://www.elkem.com/). The app provides an ability to get semantically coloured logs for applications deployed on Posit Connect by simply changing the default environment variables and deploying it on Posit Connect. Given the general usefulness of the app, we have decided to share it with the wider community to use and improve upon it. No more sifting through long text files; you can simply find the reds and see where things break. It has never been easier to investigate what goes wrong with your applications.

# How it works?

- The LogAnalyzer app uses the Posit Connect API to fetch logs for application run jobs, semantically colouring them so they are easier to read.
- The only thing you need to set this up and use is the `CONNECT_API_KEY` set as an environment variable. The idea is that the key should come from either an admin account or someone with privileges to view all apps. Apps that are not available to a user will not have their logs available to them.
- If you want to test the app locally, you will need to set the `CONNECT_SERVER` as an environment variable. When deployed, the `CONNECT_SERVER` is setup automatically for you.

![LogAnalyzerDemo](https://github.com/Appsilon/LogAnalyzer/assets/26517718/90d1111d-006b-42db-8d8b-b55ee391cb21)

# Credits
It was our collaboration with <img src="https://github.com/Appsilon/LogAnalyzer/assets/26517718/b26fd60b-4989-4d31-a01e-5cf865f5ec9b" alt="Elkem" width="50"/>  which led to the creation of this app. The initial idea came from use-cases where we realised we wanted to track all the logs and be able to read them properly since Posit Connect was the de facto deployment environment. When we made this app, we realised there was potential in sharing this with the rest of the community and invite everyone to use it and add it. We appreciate and thank Elkem for their openness to share it with the world.

You can read more about Appsilon and Elkem's collaboration on our case study [here](https://www.appsilon.com/case-studies/refining-elkems-processes-with-advanced-data-analytics).
