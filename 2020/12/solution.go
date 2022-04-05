package main

import (
	"bufio"
	"fmt"
	"io/ioutil"
	"math"
	"regexp"
	"strconv"
	"strings"
)

type instruction struct {
	direction string
	distance  int
}

func readInput() []instruction {
	input, err := ioutil.ReadFile("2020/12/input.txt")
	if err != nil {
		panic(err)
	}

	reader := strings.NewReader(string(input))
	scanner := bufio.NewScanner(reader)
	regex := regexp.MustCompile(`(\w{1})(\d+)`)

	var result []instruction
	for scanner.Scan() {
		line := scanner.Text()
		submatch := regex.FindSubmatch([]byte(line))
		direction := submatch[1]
		distance, _ := strconv.Atoi(string(submatch[2]))
		instr := instruction{string(direction), int(distance)}
		result = append(result, instr)
	}

	return result
}

func partOne(instructions []instruction) int {
	x := 0
	y := 0
	heading := 0
	for _, instr := range instructions {
		dist := instr.distance
		switch direction := instr.direction; direction {
		case "N":
			y = y + dist
		case "S":
			y = y - dist
		case "E":
			x = x + dist
		case "W":
			x = x - dist
		case "L":
			heading = (heading - (dist / 90) + 4) % 4
		case "R":
			heading = (heading + (dist / 90) + 4) % 4
		case "F":
			switch heading {
			case 0:
				x = x + dist
			case 1:
				y = y - dist
			case 2:
				x = x - dist
			case 3:
				y = y + dist
			}
		}
	}
	manhattan := math.Abs(float64(x)) + math.Abs(float64(y))
	return int(manhattan)
}

func partTwo(instructions []instruction) int {
	x := 0
	y := 0
	wx := 10
	wy := 1
	for _, instr := range instructions {
		dist := int(instr.distance)
		switch direction := instr.direction; direction {
		case "N":
			wy = wy + dist
		case "S":
			wy = wy - dist
		case "E":
			wx = wx + dist
		case "W":
			wx = wx - dist
		case "L":
			times := (dist / 90)
			for i := 0; i < times; i++ {
				nx := -wy
				ny := wx
				wx = nx
				wy = ny
			}
		case "R":
			times := (dist / 90)
			for i := 0; i < times; i++ {
				nx := wy
				ny := -wx
				wx = nx
				wy = ny
			}
		case "F":
			x = x + (wx * dist)
			y = y + (wy * dist)
		}
	}
	manhattan := math.Abs(float64(x)) + math.Abs(float64(y))
	return int(manhattan)
}

func main() {
	instructions := readInput()
	fmt.Println(partOne(instructions))
	fmt.Println(partTwo(instructions))
}
