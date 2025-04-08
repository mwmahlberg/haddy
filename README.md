Haddy
=====

This repository contains *Haddy* - [**H**ugo][hugo] on [C**addy**][caddy].

It uses the Caddy webserver, [Paul Green][gh:greenpau]'s excellent
[caddy-git][caddy:git] plugin and Hugo, a static website generator.

- [Using haddy](#using-haddy)
  - [Demo-Site](#demo-site)
  - [Quickstart](#quickstart)
  - [Using a private repository](#using-a-private-repository)
- [Using Hugo](#using-hugo)
  - [Create a new site](#create-a-new-site)

Using haddy
-----------

> Note that in production you should use a volume mounted to `/usr/local/src`.
> The reason is that a hugo theme might take a long time to download
> the first time.

### Demo-Site

The demo site uses [github.com/mwmahlberg/haddy-demosite][gh:haddy-demo].

Create a docker volume:

```shell
$ docker create volume haddy_src
haddy_src
```

Then run with the demo site:

```shell
$ docker run -v haddy_src:/usr/local/src -p 8080:80 docker.io/mwmahlberg/haddy:0.0.1-alpine3.20-caddy2.9.1
{"level":"info","ts":1744100254.9286692,"msg":"using config from file","file":"/etc/caddy/Caddyfile"}
{"level":"info","ts":1744100254.9300873,"msg":"adapted config to JSON","adapter":"caddyfile"}
{"level":"info","ts":1744100254.931229,"logger":"admin","msg":"admin endpoint started","address":"localhost:2019","enforce_origin":false,"origins":["//localhost:2019","//[::1]:2019","//127.0.0.1:2019"]}
{"level":"info","ts":1744100254.9312787,"logger":"git","msg":"provisioning app instance","app":"git"}
```

The initial download of the hugo theme will take a while.
Wait until you see the following line:

```json
{"level":"info","ts":1744101591.6987336,"logger":"git","msg":"provisioned app instance","app":"git"}
```

and then open [http://localhost:8080](http://localhost:8080).

### Quickstart

You need a public repository with a hugo site for this.

First, clone this repository and enter the directory you checked the code out into.

Then, prepare a volume for `/usr/local/src`:

```none
$ docker volume create haddy_src
haddy_src
```

Now, start haddy

```shell
$ docker run \
-e REPO=$YOUR_REPO_URL
-v haddy_src:/usr/local/src \
-v $(PWD)/Caddyfile:/etc/caddy/Caddyfile \
-p 8080:80 docker.io/mwmahlberg/haddy:0.0.1-alpine3.20-caddy2.9.1
```

### Using a private repository

Add a ssh private key to the image and reference it in the git configuration for
the repo "site".

Adjust your `Caddyfile` like this:

```none
{
   git {
      repo site {
         base_dir /usr/local/src
         url {env.REPO}
         branch main
         update every 60
         auth key {$HOME}/.ssh/id_rsa
         post pull exec {
            name hugo
            command /usr/local/bin/build.sh
         }
      }
   }
}

:80 {
   root * /srv
   file_server
}
```

```none
docker run
-v haddy_src:/usr/local/src \
-v $(PWD)/Caddyfile:/etc/caddy/Caddyfile \
-v path/to/ssh-privkey:/root/.ssh/id_rsa
-p 8080:80 \
docker.io/mwmahlberg/haddy:0.0.1-alpine3.20-caddy2.9.1
```

Further reading:

- [Caddyfile documentation][caddy:caddyfile]
- [git plugin documentation][caddy:git]
- [git ssh authentication][git:ssh]



Using Hugo
----------

Please also refer to hugo's official documentation and your theme's docs.

### Create a new site

1. Create a new hugo site.

   ```none
   hugo new site .
   ```

2. Add a [theme][hugo:themes]

   ```none
   git submodule add https://github.com/McShelby/hugo-theme-relearn.git themes/relearn
   ```

3. Configure your site to use the selected theme

   ```none
   echo "theme = 'relearn'" >> hugo.toml
   ```

4. Create a landing page for your site:

   ```none
   hugo new content content/_index.md
   ```

[hugo]: https://gohugo.io "Hugo project website"
[hugo:themes]: https://themes.gohugo.io "Hugo themes"
[caddy]: https://caddyserver.com "Caddy project website"
[gh:greenpau]: https://github.com/greenpau "GitGub profile of Paul Green"
[gh:haddy-demo]: https://github.com/mwmahlberg/haddy-demosite "Hugo demo site"
[caddy:caddyfile]: https://caddyserver.com/docs/caddyfile/concepts "Caddyfile concepts"
[caddy:git]: https://github.com/greenpau/caddy-git "caddy-git documentation"
[git:ssh]: https://git-scm.com/book/en/v2/Git-on-the-Server-Generating-Your-SSH-Public-Key "4.3 Git on the Server - Generating Your SSH Public Key"
