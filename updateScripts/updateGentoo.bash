#!/bin/bash

emerge --sync
emerge -auDN @world
emerge --depclean -a
