package main

import (
	"bufio"
	"fmt"
	"io/ioutil"
	"sort"
	"strconv"
	"strings"
)

func readInput() []int {
	input, err := ioutil.ReadFile("2020/10/input.txt")
	if err != nil {
		panic(err)
	}

	reader := strings.NewReader(string(input))
	scanner := bufio.NewScanner(reader)

	var result []int
	for scanner.Scan() {
		line := scanner.Text()
		num, _ := strconv.Atoi(line)
		result = append(result, num)
	}
	return result
}

func main() {
	numbers := readInput()
	length := len(numbers)
	sort.Ints(numbers)
	ones := 0
	threes := 1
	groups := []int{1}
	last := 0
	for i := 0; i < length; i++ {
		jump := numbers[i] - last
		last = numbers[i]
		if jump == 1 {
			ones++
			groups[len(groups)-1]++
		}
		if jump == 3 {
			threes++
			groups = append(groups, 1)
		}
	}

	group_sizes := map[int]int{1: 1, 2: 1, 3: 2, 4: 4, 5: 7}
	var sizes []int
	for _, x := range groups {
		sizes = append(sizes, group_sizes[x])
	}

	ways := 1
	for _, x := range sizes {
		ways = ways * x
	}

	fmt.Printf("%d\n", ones*threes)
	fmt.Printf("%d\n", ways)
}
