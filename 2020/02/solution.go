package main

import (
	"bufio"
	"fmt"
	"io/ioutil"
	"regexp"
	"strconv"
	"strings"
)

func readInput() [][]string {
	input, err := ioutil.ReadFile("2020/02/input.txt")

	if err != nil {
		panic(err)
	}

	reader := strings.NewReader(string(input))
	scanner := bufio.NewScanner(reader)
	re := regexp.MustCompile(`\W+`)
	var result [][]string
	for scanner.Scan() {
		array := re.Split(scanner.Text(), -1)
		result = append(result, array)
	}

	return result
}

func main() {
	input := readInput()

	part_one := 0
	part_two := 0

	for _, line := range input {
		low, _ := strconv.Atoi(line[0])
		high, _ := strconv.Atoi(line[1])
		letter := line[2]
		password := line[3]
		count := strings.Count(password, letter)
		if count >= low && count <= high {
			part_one += 1
		}
		if (password[low-1] == letter[0]) != (password[high-1] == letter[0]) {
			part_two += 1
		}
	}

	fmt.Printf("%d\n", part_one)
	fmt.Printf("%d\n", part_two)
}
