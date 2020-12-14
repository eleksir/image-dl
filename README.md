# Image-dl

## What is this?

Image downloading tool.

## What for

To download images. It can be used for im clients to save images via custom plugins.

## How it works

Asynchronously downloads given picture.

```bash
curl -H 'url: http://server.tld/image.jpg' http://localhost:3088/image_dl
```

## How to run it

As [PSGI][1] application, via [UWSGI][2].

Before running this app should be bootstrapped via bootstrap.sh and [cpanm][3].

Copy config_sample to config open it and edit, put there valid dir where images will be saved.

```bash
/usr/bin/uwsgi --yaml /var/www/image-dl/image-dl.yaml \
               --psgi /var/www/image-dl/image-dl.psgi \
               --logto /var/log/image-dl.log \
               --pidfile /var/run/image-dl.pid \
               --perl-local-lib /var/www/image-dl/vendor_perl
```

[1]: https://uwsgi-docs.readthedocs.io/en/latest/Perl.html
[2]: https://github.com/unbit/uwsgi
[3]: https://github.com/miyagawa/cpanminus
