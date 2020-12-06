const decoder = new TextDecoder('utf-8');

const text = decoder.decode(await Deno.readFile('./source.txt'));

const answersForGroup = (answers: string) => [...new Set(answers.split(""))];

const answersForGroups = text.split('\n\n')
    .map(el => el.replace(RegExp("\n", "g"), ""))
    .map(answersForGroup)
    .map((answers: string[]) => answers.length)
    .reduce((a, b) => a + b, 0);

console.log({ firstSolution: answersForGroups });


const answersForGroupsWithYesCount = text.split('\n\n')
    .map((answerGroup: string) => {
        const answers = answerGroup.split("\n");
        let potencialAnswerWithAllYes = answers[0].split("");
        for (let i: number = 1; i < answers.length; i++) {
            const anotherPersonsAnswers = answers[i].split("");
            potencialAnswerWithAllYes = potencialAnswerWithAllYes
                .filter((withYes: string) => anotherPersonsAnswers
                    .some((wy: string) => wy === withYes));
        }
        return potencialAnswerWithAllYes.length;
    })
    .reduce((a, b) => a + b, 0);


console.log({ secondSolution: answersForGroupsWithYesCount })