#!/usr/bin/env bash

reset() {
	printf '%s\n' '0'
	"$@"
}
bold() {
	printf '%s\n' '1'
	"$@"
}
halfbright() {
	printf '%s\n' '2'
	"$@"
}
italic() {
	printf '%s\n' '3'
	"$@"
}
underline() {
	printf '%s\n' '4'
	"$@"
}
blinking() {
	printf '%s\n' '5'
	"$@"
}
inverse() {
	printf '%s\n' '7'
	"$@"
}
hidden() {
	printf '%s\n' '8'
	"$@"
}
strikethrough() {
	printf '%s\n' '9'
	"$@"
}
black() {
	printf '%s\n' '30'
	"$@"
}
red() {
	printf '%s\n' '31'
	"$@"
}
green() {
	printf '%s\n' '32'
	"$@"
}
yellow() {
	printf '%s\n' '33'
	"$@"
}
blue() {
	printf '%s\n' '34'
	"$@"
}
magenta() {
	printf '%s\n' '35'
	"$@"
}
cyan() {
	printf '%s\n' '36'
	"$@"
}
gray() {
	printf '%s\n' '37'
	"$@"
}
onblack() {
	printf '%s\n' '40'
	"$@"
}
onred() {
	printf '%s\n' '41'
	"$@"
}
ongreen() {
	printf '%s\n' '42'
	"$@"
}
onyellow() {
	printf '%s\n' '43'
	"$@"
}
onblue() {
	printf '%s\n' '44'
	"$@"
}
onmagenta() {
	printf '%s\n' '45'
	"$@"
}
oncyan() {
	printf '%s\n' '46'
	"$@"
}
ongray() {
	printf '%s\n' '47'
	"$@"
}
darkgray() {
	printf '%s\n' '90'
	"$@"
}
brightred() {
	printf '%s\n' '91'
	"$@"
}
brightgreen() {
	printf '%s\n' '92'
	"$@"
}
brightyellow() {
	printf '%s\n' '93'
	"$@"
}
brightblue() {
	printf '%s\n' '94'
	"$@"
}
brightmagenta() {
	printf '%s\n' '95'
	"$@"
}
brightcyan() {
	printf '%s\n' '96'
	"$@"
}
brightgray() {
	printf '%s\n' '97'
	"$@"
}
onbrightblack() {
	printf '%s\n' '100'
	"$@"
}
onbrightred() {
	printf '%s\n' '101'
	"$@"
}
onbrightgreen() {
	printf '%s\n' '102'
	"$@"
}
onbrightyellow() {
	printf '%s\n' '103'
	"$@"
}
onbrightblue() {
	printf '%s\n' '104'
	"$@"
}
onbrightmagenta() {
	printf '%s\n' '105'
	"$@"
}
onbrightcyan() {
	printf '%s\n' '106'
	"$@"
}
onbrightgray() {
	printf '%s\n' '107'
	"$@"
}
