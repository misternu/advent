package main

import (
	"bufio"
	"fmt"
	"io/ioutil"
	"strings"
)

func readInput() (map[int]bool, map[int][]int) {
	input, err := ioutil.ReadFile("2020/11/input.txt")
	if err != nil {
		panic(err)
	}

	reader := strings.NewReader(string(input))
	scanner := bufio.NewScanner(reader)

	seat_map := make(map[int]bool)
	y := 0
	var width int
	for scanner.Scan() {
		line := scanner.Text()
		width = len(line)
		for x, c := range line {
			if c == 'L' {
				seat_map[(y*width)+x] = false
			}
		}
		y++
	}
	height := y

	neighbors := make(map[int][]int)

	directions := [][]int{[]int{0, -1}, []int{1, -1}, []int{1, 0}, []int{1, 1}, []int{0, 1}, []int{-1, 1}, []int{-1, 0}, []int{-1, -1}}
	for y := 0; y < height; y++ {
		for x := 0; x < width; x++ {
			if _, ok := seat_map[(y*width)+x]; ok {
				var p_neighbors []int
				for _, pair := range directions {
					dx := pair[0]
					dy := pair[1]
					nx := x + dx
					ny := y + dy
					if nx < 0 || ny < 0 || nx >= width || ny >= height {
						continue
					}
					key := (ny * width) + nx
					if _, n_ok := seat_map[key]; n_ok {
						p_neighbors = append(p_neighbors, key)
					}
				}
				neighbors[y*width+x] = p_neighbors
			}
		}
	}

	return seat_map, neighbors
}

func run(seat_map map[int]bool, neighbors map[int][]int) int {
	previous_map := seat_map
	running := true
	var new_map map[int]bool
	for running {
		// printMap(previous_map)
		new_map = make(map[int]bool)
		running = false
		for k := range previous_map {
			count := 0
			for _, nk := range neighbors[k] {
				if previous_map[nk] {
					count++
				}
			}
			if previous_map[k] {
				new_map[k] = count < 4
			} else {
				new_map[k] = count == 0
			}
			if new_map[k] != previous_map[k] {
				running = true
			}
		}
		previous_map = new_map
	}
	total := 0
	for _, v := range previous_map {
		if v {
			total++
		}
	}
	return total
}

func main() {
	seat_map, neighbors := readInput()

	part_one := run(seat_map, neighbors)

	fmt.Println(part_one)
}
