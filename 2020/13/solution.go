package main

import (
	"fmt"
	"io/ioutil"
	"strconv"
	"strings"
)

type busInfo struct {
	bus   int
	index int
}

func readInput() (int, []int, []busInfo) {
	input, err := ioutil.ReadFile("2020/13/input.txt")
	if err != nil {
		panic(err)
	}
	lines := strings.Split(string(input), "\n")
	timestamp, _ := strconv.Atoi(lines[0])
	busses := strings.Split(lines[1], ",")

	var partOneBusses []int
	var partTwoBusses []busInfo
	for i, bus := range busses {
		if bus != "x" {
			number, _ := strconv.Atoi(bus)
			partOneBusses = append(partOneBusses, number)
			partTwoBusses = append(partTwoBusses, busInfo{number, i})
		}
	}

	return timestamp, partOneBusses, partTwoBusses
}

func partOne(timestamp int, busses []int) int {
	bus := busses[0]
	min := timestamp * 2
	for _, number := range busses {
		times := timestamp / number
		arrival := (times + 1) * number
		if arrival < min {
			bus = number
			min = arrival
		}
	}
	return (min - timestamp) * bus
}

func remainder(a int, b int) int {
	return a - ((a / b) * b)
}

func partTwo(busses []busInfo) int {
	total := 0
	product := 1
	for _, bi := range busses {
		co := 0
		for remainder(total+(co*product)+bi.index, bi.bus) > 0 {
			co++
		}
		total = total + (co * product)
		product = product * bi.bus
	}
	return total
}

func main() {
	timestamp, partOneBusses, partTwoBusses := readInput()

	fmt.Println(partOne(timestamp, partOneBusses))
	fmt.Println(partTwo(partTwoBusses))
}
