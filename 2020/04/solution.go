package main

import (
	"fmt"
	"io/ioutil"
	"regexp"
	"strconv"
)

func readInput() []map[string]string {
	input, err := ioutil.ReadFile("2020/04/input.txt")

	if err != nil {
		panic(err)
	}

	next_passport := regexp.MustCompile("\n\n")
	next_attribute := regexp.MustCompile("\\s+")
	key_value := regexp.MustCompile(":")

	passport_strings := next_passport.Split(string(input), -1)

	var passports []map[string]string

	for _, line := range passport_strings {
		attributes := next_attribute.Split(line, -1)
		m := make(map[string]string)
		for _, attr := range attributes {
			k_v := key_value.Split(attr, -1)
			m[k_v[0]] = k_v[1]
		}
		passports = append(passports, m)
	}

	return passports
}

func validPassport(passport map[string]string) bool {
	required := [7]string{"byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"}
	attrs := 0
	for _, requirement := range required {
		_, present := passport[requirement]
		if present {
			attrs++
		}
	}
	return attrs == 7
}

func correctPassport(passport map[string]string) bool {
	byr, _ := strconv.Atoi(passport["byr"])
	if byr < 1920 {
		return false
	}
	if byr > 2002 {
		return false
	}

	iyr, _ := strconv.Atoi(passport["iyr"])
	if iyr < 2010 {
		return false
	}
	if iyr > 2020 {
		return false
	}

	eyr, _ := strconv.Atoi(passport["eyr"])
	if eyr < 2020 {
		return false
	}
	if eyr > 2030 {
		return false
	}

	hgt_pattern := `\A(1[5-8][0-9]cm|19[0-3]cm|59in|6[0-9]in|7[0-6]in)\z`
	hgt_match, _ := regexp.Match(hgt_pattern, []byte(passport["hgt"]))
	if !hgt_match {
		return false
	}

	hcl_pattern := `\A#[0-9a-f]{6}\z`
	hcl_match, _ := regexp.Match(hcl_pattern, []byte(passport["hcl"]))
	if !hcl_match {
		return false
	}

	ecl_pattern := `\A(amb|blu|brn|gry|grn|hzl|oth)\z`
	ecl_match, _ := regexp.Match(ecl_pattern, []byte(passport["ecl"]))
	if !ecl_match {
		return false
	}

	pid_pattern := `\A\d{9}\z`
	pid_match, _ := regexp.Match(pid_pattern, []byte(passport["pid"]))
	if !pid_match {
		return false
	}

	return true
}

func main() {
	passports := readInput()

	valid := 0
	correct := 0
	for _, passport := range passports {
		if !validPassport(passport) {
			continue
		}
		valid++
		if correctPassport(passport) {
			correct++
		}
	}

	fmt.Printf("%d\n", valid)
	fmt.Printf("%d\n", correct)
}
