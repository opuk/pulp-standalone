#!/bin/bash

sed -n '/-----BEGIN CERTIFICATE-----/,/-----END RSA SIGNATURE-----/p' $1 
