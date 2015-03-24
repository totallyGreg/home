#!/bin/bash

nmap -Pn -T4 -sS --top-ports 3674 --reason -sV $1
