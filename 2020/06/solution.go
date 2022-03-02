package main

import (
	"fmt"
	"io/ioutil"
	"regexp"
)

func readInput() [][]string {
	input, err := ioutil.ReadFile("2020/06/input.txt")

	if err != nil {
		panic(err)
	}

	next_group := regexp.MustCompile("\n\n")
	next_person := regexp.MustCompile("\n")
	groups := next_group.Split(string(input), -1)

	var result [][]string
	for _, group := range groups {
		people := next_person.Split(group, -1)
		result = append(result, people)
	}
	return result
}

func main() {
	groups := readInput()
	total_any := 0
	total_every := 0
	for _, group := range groups {
		answers_any := make(map[rune]bool)
		answers_every := make(map[rune]bool)
		for _, letter := range group[0] {
			answers_every[letter] = true
		}
		for _, person := range group {
			person_every := make(map[rune]bool)
			for _, letter := range person {
				answers_any[letter] = true
				if answers_every[letter] {
					person_every[letter] = true
				}
			}
			answers_every = person_every
		}
		total_any = total_any + len(answers_any)
		total_every = total_every + len(answers_every)
	}
	fmt.Printf("%d\n", total_any)
	fmt.Printf("%d\n", total_every)
}
