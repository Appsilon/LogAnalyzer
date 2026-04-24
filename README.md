# LogAnalyzer

The LogAnalyzer open-source app is a simple, plug and play application developed first in collaboration with [Elkem](https://www.elkem.com/). The app provides an ability to get semantically coloured logs for applications deployed on Posit Connect by simply changing the default environment variables and deploying it on Posit Connect. Given the general usefulness of the app, we have decided to share it with the wider community to use and improve upon it. No more sifting through long text files; you can simply find the reds and see where things break. It has never been easier to investigate what goes wrong with your applications.

# How it works?

-   The LogAnalyzer app uses the Posit Connect API to fetch logs for application run jobs, semantically colouring them so they are easier to read.
-   The only thing you need to set this up and use is the `CONNECT_API_KEY` set as an environment variable. The idea is that the key should come from either an admin account or someone with privileges to view all apps. Apps that are not available to a user will not have their logs available to them.
-   If you want to test the app locally, you will need to set the `CONNECT_SERVER` as an environment variable. When deployed, the `CONNECT_SERVER` is setup automatically for you.

![](img/app_preview.gif)

# Configuration

-   `[app/logic/api_utils.R` - `get_app_list()]` Posit Connect differentiates apps with two `app_role` values: `owner` and `viewer`. You can toggle between these using the `config.yml` file. The set value is `owner`. If you want to use both together, you can simply set the value to a blank character `""`.

# FAQs

- I get `"Oops! Can't read apps from Posit Connect."` on the rightmost image?
    - This may mean that the Posit Connect API's response did not send proper data.
    - So far, one documented reason for this is that OAuth on Posit Connect instances may prevent the `/content` endpoint from sending app data.
- How do I rebrand the application?
    - You can edit the branding in the `config.yml` file. You'll find the `colors` key which will build the CSS.
    - The three status colors and their highlights e.g. `red` and `red-highlight` color the logs for you.
    - The `primary` color is the primary theme for your application. This also affects SVGs.
    - The blacks, whites and greys fill in the rest of the UI elements such as text, separator et al.
- How do I recolor the SVGs?
    - This requires some creativity. We recommend replacing the primary color hex which you can find in the `.svg` file as `fill="#hexcde"` to `PRIMARY`.
    - We use this as a default value in the function that replaces it but you are welcome to use another value and modify the function.

# Credits

It was our collaboration with <img src="img/elkem_logo.png" alt="Elkem" width="50"/> which led to the creation of this app. The initial idea came from use-cases where we realised we wanted to track all the logs and be able to read them properly since Posit Connect was the de facto deployment environment. When we made this app, we realised there was potential in sharing this with the rest of the community and invite everyone to use it and add it. We appreciate and thank Elkem for their openness to share it with the world.

You can read more about Appsilon and Elkem's collaboration on our case study [here](https://www.appsilon.com/case-studies/refining-elkems-processes-with-advanced-data-analytics).

## Appsilon

<img src="https://avatars0.githubusercontent.com/u/6096772" align="right" width="6%"/>

Appsilon is a **Posit (formerly RStudio) Full Service Certified Partner**.<br/> Learn more at [appsilon.com](https://appsilon.com).

Get in touch [opensource\@appsilon.com](mailto:opensource@appsilon.com)

Explore the [Rhinoverse](https://rhinoverse.dev) - a family of R packages built around [Rhino](https://appsilon.github.io/rhino/)!

<a href = "https://appsilon.us16.list-manage.com/subscribe?u=c042d7c0dbf57c5c6f8b54598&id=870d5bfc05" target="_blank"> <img src="https://raw.githubusercontent.com/Appsilon/website-cdn/gh-pages/shiny_weekly_light.jpg" alt="Subscribe for Shiny tutorials, exclusive articles, R/Shiny community events, and more." id="footer-banner"/> </a>
