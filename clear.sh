#!/bin/bash
rake db:drop && rake db:create && rake db:migrate
rm public/img/* public/img/thumbs/* public/img/previews/* storage/images/*