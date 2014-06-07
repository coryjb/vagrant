#!/bin/bash

while :;
	do
	clear;
	echo "Syching";
	vagrant rsync;
	echo "Sleeping for 5 seconds";
	sleep 5;
done