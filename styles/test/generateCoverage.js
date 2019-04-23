const fs = require('fs')
const inputFile = process.argv[2]

const CODECOVERAGE_COVERED = '__CODECOVERAGE_COVERED: '
const CODECOVERAGE_ALL_POSSIBLE = '__CODECOVERAGE_ALL_POSSIBLE: '

const coverageFiles = new Map/* <string, FileCoverage> */()

class FileCoverage {
  constructor (allPossibleLines) {
    this.allPossibleLines = allPossibleLines
    this.coveredCount = [] // sparse array
  }
  addCovered (line) {
    this.coveredCount[line] = this.coveredCount[line] || 0
    this.coveredCount[line]++
  }
}

function addAllPossible ([filename, lines]) {
  if (coverageFiles.has(filename)) {
    throw new Error(`BUG: duplicate definition of all covered lines for '${filename}'`)
  }
  coverageFiles.set(filename, new FileCoverage(lines))
}

function addCovered ([filename, line]) {
  const cov = coverageFiles.get(filename)
  if (!cov) {
    throw new Error(`BUG: line was counted before it was defined`)
  }
  cov.addCovered(line)
}

fs.readFileSync(inputFile, 'utf-8').split('\n').forEach((line, inputLineNumber) => {
  const coveredStart = line.indexOf(CODECOVERAGE_COVERED)
  const allPossibleStart = line.indexOf(CODECOVERAGE_ALL_POSSIBLE)
  if (coveredStart >= 0) {
    const json = JSON.parse(line.substring(coveredStart + CODECOVERAGE_COVERED.length))
    addCovered(json)
  } else if (allPossibleStart >= 0) {
    const json = JSON.parse(line.substring(allPossibleStart + CODECOVERAGE_ALL_POSSIBLE.length))
    addAllPossible(json)
  } else if (line.length === 0) {
    // skip
  } else {
    // Ignore generic @debug messages that are in the log
  }
})

// Generate the coverage file
const ret = []
for (const [filename, cov] of coverageFiles.entries()) {
  let nonZero = 0
  let allCounter = 0
  ret.push(`SF:${filename}`)
  for (const line of cov.allPossibleLines) {
    const count = cov.coveredCount[line] || 0
    ret.push(`DA:${line},${count}`)
    if (count > 0) {
      nonZero += 1
    }
    allCounter += 1
  }
  // Include summary info for the file
  ret.push(`LH:${nonZero}`)
  ret.push(`LF:${allCounter}`)
  ret.push(`end_of_record`)
}
console.log(ret.join('\n'))
