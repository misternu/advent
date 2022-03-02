package main

import (
	"bufio"
	"fmt"
	"io/ioutil"
	"regexp"
	"strconv"
	"strings"
)

type rule struct {
	count int
	color string
}

func readInput() map[string][]rule {
	input, err := ioutil.ReadFile("2020/07/input.txt")
	if err != nil {
		panic(err)
	}

	reader := strings.NewReader(string(input))
	scanner := bufio.NewScanner(reader)
	container := regexp.MustCompile(`\A(.*) bags contain`)
	empty := regexp.MustCompile(`bags contain no other bags.`)
	contained := regexp.MustCompile(`(\d+) (\w+ \w+) bag`)

	result := make(map[string][]rule)
	for scanner.Scan() {
		line := scanner.Text()
		outer := container.FindSubmatch([]byte(line))[1]
		is_empty := empty.Match([]byte(line))

		if is_empty {
			result[string(outer)] = []rule{}
		} else {
			inner := contained.FindAllSubmatch([]byte(line), -1)
			var rules []rule
			for _, rule_match := range inner {
				count, _ := strconv.Atoi(string(rule_match[1]))
				color := string(rule_match[2])
				this_rule := rule{count, color}
				rules = append(rules, this_rule)
			}
			result[string(outer)] = rules
		}
	}
	return result
}

func containsGold(rules map[string][]rule, key string) bool {
	if key == "shiny gold" {
		return true
	}
	contained := rules[key]
	if len(contained) == 0 {
		return false
	}
	for _, rule := range contained {
		if containsGold(rules, rule.color) {
			return true
		}
	}
	return false
}

func containedBags(rules map[string][]rule, key string, co int) int {
	sum := 0
	contained := rules[key]
	for _, rule := range contained {
		sum = sum + rule.count + containedBags(rules, rule.color, rule.count)
	}
	return co * sum
}

func main() {
	rules := readInput()
	contain_gold := 0
	for key := range rules {
		if key == "shiny gold" {
			continue
		}
		if containsGold(rules, key) {
			contain_gold++
		}
	}
	contained_by_gold := containedBags(rules, "shiny gold", 1)
	fmt.Printf("%d\n", contain_gold)
	fmt.Printf("%d\n", contained_by_gold)
}
