#!/bin/bash
emerge --sync
emerge -uDNav @world
emerge --depclean -a
