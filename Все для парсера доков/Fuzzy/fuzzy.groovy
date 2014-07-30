def origs = new File('origs').text.split('\n')*.toLowerCase()*.replaceAll(/\s|-/, '')*.trim() as Set
def words = new File('words').text.split('\n')*.toLowerCase()*.replaceAll(/\s|-/, '')*.trim().grep { !it.empty }

//println words.size()
//println words.collect { origs.contains(it) }.grep { it }.size() / words.size()

//exit(0)

//def metric = new ru.fuzzysearch.LevensteinMetric()
def metric = new ru.fuzzysearch.DamerauLevensteinMetric()
def result = words.collect { word ->
    def entry = origs.collectEntries { [it, metric.getDistance(it, word, 10)] }.min { it.value }
    [
        word: word,
        find: entry.key,
        dist: entry.value
    ]
}.grep { it.dist in [0, 1] }

//println result.grep { it.dist in [0, 1] }.size() / words.size()

println result.collect { "$it.word|$it.find|$it.dist" }.join('\n')

