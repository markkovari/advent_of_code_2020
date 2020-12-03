package main

import (
	"bufio"
	"log"
	"os"
	"strconv"
	"strings"
	"unicode/utf8"
)

type PasswordPolicy struct {
	min                int64
	max                int64
	password           string
	charShouldCointain rune
}

func violatedPasswordPolicy(pp PasswordPolicy) bool {
	var containsTimes int64 = 0
	for _, letter := range pp.password {
		if letter == pp.charShouldCointain {
			containsTimes += 1
		}
	}
	return pp.min <= containsTimes && containsTimes <= pp.max
}

func violatedPasswordPolicyCorrected(pp PasswordPolicy) bool {
	lettersOfPassword := strings.Split(pp.password, "")
	firstAsRune, _ := utf8.DecodeRuneInString(lettersOfPassword[pp.min-1])
	sedondAsRune, _ := utf8.DecodeRuneInString(lettersOfPassword[pp.max-1])
	firstMaches := firstAsRune == pp.charShouldCointain
	secondMaches := sedondAsRune == pp.charShouldCointain
	return (firstMaches || secondMaches) && !(firstMaches && secondMaches)
}

func fromLine(line string) (pp PasswordPolicy, err error) {
	lineParts := strings.Split(line, " ")
	pp.password = lineParts[2]
	minMaxAsStrings := strings.Split(lineParts[0], "-")
	parsed, err := strconv.ParseInt(minMaxAsStrings[0], 10, 64)
	if err != nil {
		return pp, err
	}
	pp.min = parsed
	parsed, err = strconv.ParseInt(minMaxAsStrings[1], 10, 64)
	if err != nil {
		return pp, err
	}
	pp.max = parsed
	expectedchar := strings.Split(lineParts[1], ":")[0]
	r, size := utf8.DecodeRuneInString(expectedchar)
	if size == 0 {
		return pp, err
	}
	pp.charShouldCointain = r
	return pp, nil
}

var passwordPolicies []PasswordPolicy

func init() {
	file, err := os.Open("./source.txt")
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		parsed, err := fromLine(scanner.Text())
		if err != nil {
			log.Fatal("Cannot parse file content")
		}
		passwordPolicies = append(passwordPolicies, parsed)
	}

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}
}

func main() {
	sumOfViolatedPasswordPolicies := 0
	sumOfCorrectedPolicyViolationCount := 0
	for _, policy := range passwordPolicies {
		if violatedPasswordPolicy(policy) {
			sumOfViolatedPasswordPolicies += 1
		}
		if violatedPasswordPolicyCorrected(policy) {
			sumOfCorrectedPolicyViolationCount += 1
		}
	}
	println(sumOfViolatedPasswordPolicies)
	println(sumOfCorrectedPolicyViolationCount)

}
