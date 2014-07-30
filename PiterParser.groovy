
/**
 * Created with IntelliJ IDEA.
 * User: vlad
 * Date: 29.07.14
 * Time: 11:47
 * To change this template use File | Settings | File Templates.
 */
import org.apache.poi.hssf.usermodel.HSSFWorkbook
import org.apache.poi.poifs.filesystem.POIFSFileSystem
import org.apache.poi.ss.usermodel.Cell
import org.apache.poi.ss.usermodel.DateUtil
import org.apache.poi.ss.usermodel.Row
import org.apache.poi.ss.usermodel.Sheet
import static org.apache.poi.ss.usermodel.CellStyle.*
import static org.apache.poi.ss.usermodel.IndexedColors.*

//org.apache.commons.lang3.StringUtils.getLevenshteinDistance()

def getAddress(def cell) {

    def address = ""
    switch (cell.cellType) {
        case Cell.CELL_TYPE_STRING:
            address = cell.getRichStringCellValue().getString()
            break
        case Cell.CELL_TYPE_NUMERIC:
            address = cell.getNumericCellValue() as int
            break
    }

    address
}

def getUnsignedIntFieldWithout0(def cell) {

    def intValue = ""
    if(cell.cellType == Cell.CELL_TYPE_NUMERIC && cell.getNumericCellValue() > 0) {
        intValue =  cell.getNumericCellValue() as int
    }

    intValue
}

def getUnsignedFloatFieldsWithout0(def cell) {

    def floatValue = ""
    if(cell.cellType == Cell.CELL_TYPE_NUMERIC && cell.getNumericCellValue() > 0) {
        floatValue =  cell.getNumericCellValue()
    }

    floatValue
}

def getUnsignedIntField(def cell) {

    def intValue = ""
    if(cell.cellType == Cell.CELL_TYPE_NUMERIC && cell.getNumericCellValue() >= 0) {
        intValue =  cell.getNumericCellValue() as int
    }

    intValue
}

def getUnsignedFloatField(def cell) {

    def floatValue = ""
    if(cell.cellType == Cell.CELL_TYPE_NUMERIC && cell.getNumericCellValue() >= 0) {
        floatValue =  cell.getNumericCellValue()
    }

    floatValue
}

def getEnterDiametr(def cell) {

    def floatValue = ""
    if(cell.cellType == Cell.CELL_TYPE_NUMERIC && cell.getNumericCellValue() >= 0 && cell.getNumericCellValue() <= 200) {
        floatValue =  cell.getNumericCellValue()
    }

    floatValue
}

def getEnterPressure(def cell) {

    def floatValue = ""
    if(cell.cellType == Cell.CELL_TYPE_NUMERIC && cell.getNumericCellValue() >= 0 && cell.getNumericCellValue() <= 17) {
        floatValue = cell.getNumericCellValue()
    }

    floatValue
}

def getCountLiftNodes(def cell) {

    def intValue = ""
    if(cell.cellType == Cell.CELL_TYPE_NUMERIC && cell.getNumericCellValue() >= 0) {
        intValue = cell.getNumericCellValue() as int
    }
    else if(cell.cellType == Cell.CELL_TYPE_STRING) {
        def word = cell.getRichStringCellValue().getString()

        def permissibleValues = ['АУУ'] as Set
        def keyValues = ['АУУ':'АУУ','нет':'0']

        intValue = getNearestWordInDictionary(permissibleValues, keyValues, word, 2)

    }

    intValue
}



def getContractLoad2013(def cell) {
    def floatValue = ""
    if(cell.cellType == Cell.CELL_TYPE_NUMERIC && cell.getNumericCellValue() >= 0.01 && cell.getNumericCellValue() <= 25) {
        floatValue = cell.getNumericCellValue()
    }

    floatValue
}

def getBtiCode(def cell) {

    def intValue = ""
    if(cell.cellType == Cell.CELL_TYPE_NUMERIC && cell.getNumericCellValue() > 0 && ((cell.getNumericCellValue() as int) as String).length() > 2) {
        intValue =  cell.getNumericCellValue() as int
    }

    intValue
}

def getYear(def cell) {

    def intValue = ""
    if(cell.cellType == Cell.CELL_TYPE_NUMERIC && cell.getNumericCellValue() > 0 && ((cell.getNumericCellValue() as int) as String).length() == 4) {
        intValue =  cell.getNumericCellValue() as int
    }

    intValue
}

def getSearchWordInDictionaryWord(Set<String> dictionary, String word) {
    def nearestWord = ""

    dictionary.each {
        def sb= new StringBuffer(it.toLowerCase().trim())
        word = word.toLowerCase().trim()
        if(sb.indexOf(word) != -1) {
            nearestWord = it
        }
    }

    nearestWord
}

def getDictionaryWordInSearchWord(def dictionary, String word) {
    def nearestWord = ""

    def sb= new StringBuffer(word.toLowerCase().trim())

        dictionary.eachWithIndex{ dict, value ->
            if(sb.indexOf(dict.key.toString().toLowerCase().trim()) != -1) {
                nearestWord = dict.value
            }
        }

    nearestWord
}

def getNearestWordInDictionary(Set<String> dictionary, def keyValues, def word, int maxDistance) {
    def nearestWord = ""

    nearestWord = getDictionaryWordInSearchWord(keyValues, word)
    if(nearestWord != "") {
        return nearestWord
    }

    nearestWord = getSearchWordInDictionaryWord(dictionary, word)
    if(nearestWord != "") {
        return nearestWord
    }

    def metric = new ru.fuzzysearch.DamerauLevensteinMetric()
    def dist = dictionary.collectEntries { [it, metric.getDistance(it.toLowerCase().trim(), word.toLowerCase().trim(), 10)] }.min{ it.value }
    if(dist.value < maxDistance) {
        return dist.key
    }

    return ""
}

def getMkdUpravForm(def cell) {
    def permissibleValues = ['ГУП ДЕЗ', 'Частная управляющая организация', 'ТСЖ',
            'ЖК', 'ЖСК', 'непосредственное управление', 'орг-ия с гос. участием', 'организация с государственным участием',
            'ЧУО', 'частная управляющая организация', 'ГУЖА', 'гос. учр-ие жилищное агентство',
            'государственное учреждение жилищное агентство', 'жилищное агентство', 'РЖА', 'Районное жилищное агентство'] as Set
    def keyValues = ['ДЕЗ':'ГУП ДЕЗ', 'управляющая':'ЧУО', 'частная':'ЧУО', 'ЧУО':'ЧУО',
            'ТСЖ':'ТСЖ', 'ЖК':'ЖК', 'ЖСК':'ЖСК', 'управление':'непосредственное управление', 'непосредств':'непосредственное управление',
            'участием':'орг-ия с гос. участием', 'государ':'орг-ия с гос. участием','организация с государственным участием':'орг-ия с гос. участием',
            'государственное учреждение жилищное агентство':'ГУЖА','гос. учр-ие жилищное агентство':'ГУЖА', 'жилищ':'ГУЖА', 'агент':'ГУЖА',
            'Районное жилищное агентство':'РЖА', 'Районное':'РЖА']

    def mkdUpravForm = ""

    if(cell.cellType == Cell.CELL_TYPE_STRING) {
        def word = cell.getRichStringCellValue().getString()
        mkdUpravForm = getNearestWordInDictionary(permissibleValues, keyValues, word, 2)
    }

    mkdUpravForm
}

def getCategory(def cell) {
    def permissibleValues = ['ведомственный дом', 'общежитие', 'дом гостиничного типа', 'аварийный', 'под снос',
            'сцепка', 'культурного наследия', 'на техническом обслуживании'] as Set
    def keyValues = ['ведомств':'ведомственный дом', 'общеж':'общежитие', 'гостин':'дом гостиничного типа', 'авари':'аварийный',
            'снос':'под снос', 'сцеп':'сцепка', 'культур':'культурного наследия', 'технич':'на техническом обслуживании']
    def category = ""

    if(cell.cellType == Cell.CELL_TYPE_STRING) {
        def word = cell.getRichStringCellValue().getString()
        category = getNearestWordInDictionary(permissibleValues, keyValues, word, 3)
    }

    category
}

def getHouseType(def cell) {
    def permissibleValues = ['блочный', 'брежневка', 'индивидуальный', 'кирпично-монолитный', 'монолит',
            'панельный', 'сталинка', 'хрущевка', 'кирпичный', 'другое'] as Set
    def keyValues = ['блочн':'блочный', 'брежн':'брежневка', 'индивид':'индивидуальный', 'кирп':'кирпичный',
            'монол':'монолит', 'панел':'панельный', 'сталин':'сталинка', 'хрущ':'хрущевка', 'друг':'другое' ]
    def houseType = ""

    if(cell.cellType == Cell.CELL_TYPE_STRING) {
        def word = cell.getRichStringCellValue().getString()
        houseType = getNearestWordInDictionary(permissibleValues, keyValues, word, 3)
    }

    houseType
}

def getSeries(def cell) {
    def permissibleValues = ['II-01','II-02','II-03','II-04','II-05','II-07','II-08','II-14','II-17','II-18/12','II-18/9',
            'II-20','II-28','II-29','II-32','II-34','II-35','II-49','II-57','II-66','II-68','II-68-02','II-68-03','II-68-04',
            'III/17','121','131','137','1-305','1-405','1-440','1-447','1-507','1-510','1-511','1-513','1-515/5','1-515/9м',
            '1-515/9ш','1-527','1-528','1-528КП-40','1-528КП-41','1-528КП-80','1-528КП-82','1605/12','1605/9','1-ЛГ-600-I',
            '1-мг-600','1-мг-601','600 (1-ЛГ-600)','602 (1-ЛГ-602)','606 (1-ЛГ-606)','Бекерон','В-2002','ГМС-1','И-155',
            'И-1723','И-1724','И-2076','И-209а','И-491а','И-521а','И-522а','И-700','И-700А','И-760а','ИП-46С','К-7','Колос',
            'МГ-1','МГ-2','П-111','П-3','П-30','П-3М','П-42','П-43','П-44','П-44М','П-44Т','П-46','П-55','ПД-1','ПД-3','ПД-4',
            'ПП-70','ПП-83','Ш5733','Щ9378','Юникон','индивидуальный','другое'] as Set
    def keyValues = ['Юник':'Юникон','индивид':'индивидуальный','lheu':'другое']
    def series = ""

    if(cell.cellType == Cell.CELL_TYPE_STRING) {
        def word = cell.getRichStringCellValue().getString()
        series = getNearestWordInDictionary(permissibleValues, keyValues, word, 2)
    }

    series
}

def getWallType(def cell) {
    def permissibleValues = ['железобетонные','блочные','панельные','кирпичные','монолитные','деревянные','другое'] as Set
    def keyValues = ['желез':'железобетонные','блоч':'блочные','панел':'панельные','кирп':'кирпичные','монол':'монолитные',
            'дерев':'деревянные','друг':'другое']
    def wallType = ""

    if(cell.cellType == Cell.CELL_TYPE_STRING) {
        def word = cell.getRichStringCellValue().getString()
        wallType = getNearestWordInDictionary(permissibleValues, keyValues, word, 3)
    }

    wallType
}

def getSquare(def cell) {

    def intValue = ""
    if(cell.cellType == Cell.CELL_TYPE_NUMERIC && (cell.getNumericCellValue() >= 50)) {
        intValue = cell.getNumericCellValue()
    }

    intValue
}

def getYesNoField(def cell) {
    def permissibleValues = ['да','нет'] as Set
    def keyValues = ['д':'да','н':'нет', '0':'нет']
    def yesNoField = ""

    if(cell.cellType == Cell.CELL_TYPE_STRING) {
        def word = cell.getRichStringCellValue().getString()
        yesNoField = getNearestWordInDictionary(permissibleValues, keyValues, word, 2)
    }

    yesNoField
}

def getConnectionType(def cell) {
    def permissibleValues = ['ИТП','ЦТП','Тепловая сеть'] as Set
    def keyValues = ['ИТП':'ИТП','ЦТП':'ЦТП', 'тепл':'Тепловая сеть', 'сеть':'Тепловая сеть']
    def сonnectionType = ""

    if(cell.cellType == Cell.CELL_TYPE_STRING) {
        def word = cell.getRichStringCellValue().getString()
        сonnectionType = getNearestWordInDictionary(permissibleValues, keyValues, word, 2)
    }

    сonnectionType
}

def getSystemType(def cell) {
    def permissibleValues = ['закрытая','открытая'] as Set
    def keyValues = ['закр':'закрытая','откр':'открытая']
    def systemType = ""

    if(cell.cellType == Cell.CELL_TYPE_STRING) {
        def word = cell.getRichStringCellValue().getString()
        systemType = getNearestWordInDictionary(permissibleValues, keyValues, word, 2)
    }

    systemType
}

def getResourceType(def cell) {
    def permissibleValues = ['тепловая энергия','горячая вода','отопление'] as Set
    def keyValues = ['тепл':'тепловая энергия','энерг':'тепловая энергия','гор':'горячая вода', 'вод':'горячая вода', 'отопл':'отопление']
    def resourceType = ""

    if(cell.cellType == Cell.CELL_TYPE_STRING) {
        def word = cell.getRichStringCellValue().getString()
        resourceType = getNearestWordInDictionary(permissibleValues, keyValues, word, 2)
    }

    resourceType
}

def getMesUnits(def cell) {
    def permissibleValues = ['Гкал','куб.м'] as Set
    def keyValues = ['Гкал':'Гкал','куб':'куб.м','м':'куб.м']
    def mesUnits = ""

    if(cell.cellType == Cell.CELL_TYPE_STRING) {
        def word = cell.getRichStringCellValue().getString()
        mesUnits = getNearestWordInDictionary(permissibleValues, keyValues, word, 2)
    }

    mesUnits
}

def getSystemType2(def cell) {
    def permissibleValues = ['местная','центральная'] as Set
    def keyValues = ['мест':'местная','центр':'центральная']
    def systemType2 = ""

    if(cell.cellType == Cell.CELL_TYPE_STRING) {
        def word = cell.getRichStringCellValue().getString()
        systemType2 = getNearestWordInDictionary(permissibleValues, keyValues, word, 2)
    }

    systemType2
}

def getHeatingConnection(def cell) {
    def permissibleValues = ['элеватор','безэлеватор'] as Set
    def keyValues = ['элев':'элеватор','безэлев':'безэлеватор', 'элеватор':'элеватор','безэлеватор':'безэлеватор']
    def heatingConnection = ""

    if(cell.cellType == Cell.CELL_TYPE_STRING) {
        def word = cell.getRichStringCellValue().getString()
        heatingConnection = getNearestWordInDictionary(permissibleValues, keyValues, word, 2)
    }

    heatingConnection
}

def getTemperatureGrafic(def cell) {
    def permissibleValues = ['95-70','105-70','120-70', '150-70', '125-70', '130-70', '70-50', '90-70', '120-90'] as Set
    def keyValues = ['95':'95-70','105':'105-70','120':'120-70', '150':'150-70', '125':'125-70', '130':'130-70', '70-50':'70-50', '90':'90-70', '120-90':'120-90']
    def temperatureGrafic = ""

    if(cell.cellType == Cell.CELL_TYPE_STRING) {
        def word = cell.getRichStringCellValue().getString()
        temperatureGrafic = getNearestWordInDictionary(permissibleValues, keyValues, word, 2)
    }

    temperatureGrafic
}

def getHeatingGrafic(def cell) {
    def permissibleValues = ['95/70','105/70','120/70', '150/70', '125/70', '130/70', '70/50', '90/70', '120/90'] as Set
    def keyValues = ['95':'95/70','105':'105/70','120':'120/70', '150':'150/70', '125':'125/70', '130':'130/70', '70-50':'70/50', '90':'90/70', '120-90':'120/90']
    def temperatureGrafic = ""

    if(cell.cellType == Cell.CELL_TYPE_STRING) {
        def word = cell.getRichStringCellValue().getString()
        temperatureGrafic = getNearestWordInDictionary(permissibleValues, keyValues, word, 2)
    }

    temperatureGrafic
}

def getHeatingScheme(def cell) {
    def permissibleValues = ['зависимая','независимая','зависимая/независимая'] as Set
    def keyValues = ['завис':'зависимая','независ':'независимая',
            'незавимая':'независимая',
            'зависимая/независимая':'зависимая/независимая',
            'независимая/зависимая':'зависимая/независимая',
            'независимая+зависитмая':'зависимая/независимая']
    def heatingConnection = ""

    if(cell.cellType == Cell.CELL_TYPE_STRING) {
        def word = cell.getRichStringCellValue().getString()
        heatingConnection = getNearestWordInDictionary(permissibleValues, keyValues, word, 2)
    }

    heatingConnection
}

def getHeatingTransit(def cell) {
    def permissibleValues = ['разгружен','не разгружен','отсутствует'] as Set
    def keyValues = ['разгр':'разгружен','не разгр':'не разгружен','неразгр':'не разгружен',
            'отсу':'отсутствует', 'нет':'разгружен']
    def heatingConnection = ""

    if(cell.cellType == Cell.CELL_TYPE_STRING) {
        def word = cell.getRichStringCellValue().getString()
        heatingConnection = getNearestWordInDictionary(permissibleValues, keyValues, word, 2)
    }

    heatingConnection
}

def getMrMonth(def cell) {
    def permissibleValues = ['Д','Дср','Р','ОДПУ','ОДДУ','Нр'] as Set
    def keyValues = ['Д':'Д','Дср':'Дср','Р':'Р','ОДПУ':'ОДПУ','ОДДУ':'ОДДУ','Нр':'Нр','Н':'Нр']
    def heatingConnection = ""

    if(cell.cellType == Cell.CELL_TYPE_STRING) {
        def word = cell.getRichStringCellValue().getString()
        heatingConnection = getNearestWordInDictionary(permissibleValues, keyValues, word, 2)
    }

    heatingConnection
}


def parseSheetMKD(Sheet sheetMKD, fields) {
    def addressFields = [fields[1], fields[2], fields[3], fields[4], fields[5], fields[6]]
    def unsignedIntFieldsWithout0 = [fields[0], fields[14], fields[16], fields[17]]
    def unsignedIntFields = [fields[15], fields[31], fields[32], fields[33], fields[34], fields[35], fields[36]]
    def btiCode = [fields[7]]
    def year = [fields[12]]
    def mkdUpravForm = [fields[8]]
    def category = [fields[9]]
    def houseType = [fields[10]]
    def series = [fields[11]]
    def wallType = [fields[13]]
    def square = [fields[18], fields[19], fields[20], fields[21]]
    def yesNo = [fields[22], fields[23], fields[24], fields[25], fields[26], fields[27], fields[28], fields[29], fields[30]]

    def parsedSheet = [:]

    Iterator<Row> rows=sheetMKD.rowIterator()
    int i = 0
    while (rows.hasNext()) {
        Row row = (Row) rows.next()
        Iterator cells = row.cellIterator()

        def tmpRow = [:]
        while (cells.hasNext()) {
            Cell cell = (Cell) cells.next()
            int j = cell.columnIndex

            if(addressFields.contains(fields[j])) {
                tmpRow[fields[j]] = getAddress(cell)
            }
           else if(unsignedIntFieldsWithout0.contains(fields[j])) {
                tmpRow[fields[j]] = getUnsignedIntFieldWithout0(cell)
            }
            else if(unsignedIntFields.contains(fields[j])) {
                tmpRow[fields[j]] = getUnsignedIntField(cell)
            }
            else if(btiCode.contains(fields[j])) {
                tmpRow[fields[j]] = getBtiCode(cell)
            }
            else if(year.contains(fields[j])) {
                tmpRow[fields[j]] = getYear(cell)
            }
            else if(mkdUpravForm.contains(fields[j])) {
                tmpRow[fields[j]] = getMkdUpravForm(cell)
            }
            else if(category.contains(fields[j])) {
                tmpRow[fields[j]] = getCategory(cell)
            }
            else if(houseType.contains(fields[j])) {
                tmpRow[fields[j]] = getHouseType(cell)
            }
            else if(series.contains(fields[j])) {
                tmpRow[fields[j]] = getSeries(cell)
            }
            else if(wallType.contains(fields[j])) {
                tmpRow[fields[j]] = getWallType(cell)
            }
            else if(square.contains(fields[j])) {
                tmpRow[fields[j]] = getSquare(cell)
            }
            else if(yesNo.contains(fields[j])) {
                tmpRow[fields[j]] = getYesNoField(cell)
            }


        }

        parsedSheet[i] = tmpRow

        i++
    }

    def differentValues = []

    parsedSheet.each {
        if(!differentValues.contains(it.value[fields[10]])) {
            differentValues.add(it.value[fields[10]])
        }
    }

    parsedSheet
}

def getArrayMKD(String fileName, def fields, int sheetNumber)
{
    InputStream inp = new FileInputStream(fileName)

    POIFSFileSystem xssfwb = new POIFSFileSystem(inp)
    HSSFWorkbook wb = new HSSFWorkbook(xssfwb)
    Sheet sheet = wb.getSheetAt(sheetNumber)

    def parsedSheet = parseSheetMKD(sheet, fields)

    inp.close()

    parsedSheet
}

def exportExcelMKD(def resultArray, def fields) {
    new HSSFWorkbook().with { workbook ->
        def styles = [ LIGHT_BLUE, LIGHT_GREEN, LIGHT_ORANGE ].collect { color ->
            createCellStyle().with { style ->
                fillForegroundColor = color.index
                fillPattern = SOLID_FOREGROUND
                style
            }
        }
        createSheet( 'Output' ).with { sheet ->
            resultArray.each{str ->
                createRow( str.key ).with { row ->
                    int i = 0
                    while (i < fields.size()) {
                        createCell( i ).with { cell ->
                            if(str.value.containsKey(fields[i])) {
                                setCellValue( str.value[fields[i]])
                            }
                            else {
                                setCellValue("")
                            }
                        }
                        i++
                    }
                }
            }
            new File('/tmp/house.xls').withOutputStream { os ->
                write( os )
            }
        }
    }
}

def parseMKDSheet(def fileName) {

    def fields = [0:'id_in_file', 1:'okrug', 2:'raion', 3:'street', 4:'house', 5:'korpus', 6:'stroenie', 7:'bticode', 8:'mkd_uprav_form',
            9:'category', 10:'house_type', 11:'series', 12:'year_built', 13:'wall_type', 14:'floors', 15:'underfloors', 16:'porches',17:'flats',
            18:'full_area', 19:'heating_area', 20:'living_area', 21:'nonliving_area', 22:'electricity', 23:'water_cold', 24:'water_hot',
            25:'sewerage',26:'heat_supply',27:'gas_supply',28:'gas_heaters',29:'gas_ovens',30:'electro_ovens',31:'lifts_count',32:'e_devices_count',
            33:'cw_devices_count',34:'hw_devices_count',35:'heat_devices_count',36:'gas_devices_count']

    def resultArray = getArrayMKD(fileName, fields, 0)

    exportExcelMKD(resultArray, fields)
}

def parseSheetTE(Sheet sheetMKD, fields) {
    def addressFields = [fields[2], fields[5], fields[19]]
    def unsignedFloatFieldsWithout0 = [fields[20], fields[21], fields[22], fields[24], fields[26], fields[28], fields[40], fields[42], fields[44], fields[46]]
    def unsignedFloatFields = [fields[30], fields[32], fields[34], fields[36], fields[38]]
    def unsignedIntFields = [fields[8]]
    def btiCode = [fields[1]]
    def yesNo = [fields[13], fields[14], fields[15], fields[16], fields[18]]
    def connectionType = [fields[3]]
    def systemType = [fields[4]]
    def resourceType = [fields[6]]
    def mesUnits = [fields[7]]
    def systemType2 = [fields[9]]
    def enterDiametr = [fields[10]]
    def enterPressure = [fields[11]]
    def heatingConnection = [fields[17]]
    def contractLoad2013 = [fields[47]]
    def temperatureGrafic = [fields[48]]
    def heatingGrafic = [fields[12]]
    def heatingScheme = [fields[49]]
    def countLiftNodes = [fields[50]]
    def heatingTransit = [fields[51]]
    def mrMonth = [fields[23], fields[25], fields[27], fields[29], fields[31], fields[33], fields[35], fields[37], fields[39], fields[41], fields[43], fields[45]]

    def parsedSheet = [:]

    Iterator<Row> rows=sheetMKD.rowIterator()
    int i = 0
    while (rows.hasNext()) {
        Row row = (Row) rows.next()
        Iterator cells = row.cellIterator()

        def tmpRow = [:]
        while (cells.hasNext()) {
            Cell cell = (Cell) cells.next()
            int j = cell.columnIndex

            if(addressFields.contains(fields[j])) {
                tmpRow[fields[j]] = getAddress(cell)
            }
            else if(unsignedFloatFieldsWithout0.contains(fields[j])) {
                tmpRow[fields[j]] = getUnsignedFloatFieldsWithout0(cell)
            }
            else if(unsignedIntFields.contains(fields[j])) {
                tmpRow[fields[j]] = getUnsignedIntField(cell)
            }
            else if(unsignedFloatFields.contains(fields[j])) {
                tmpRow[fields[j]] = getUnsignedFloatField(cell)
            }
            else if(btiCode.contains(fields[j])) {
                tmpRow[fields[j]] = getBtiCode(cell)
            }
            else if(connectionType.contains(fields[j])) {
                tmpRow[fields[j]] = getConnectionType(cell)
            }
            else if(systemType.contains(fields[j])) {
                tmpRow[fields[j]] = getSystemType(cell)
            }
            else if(resourceType.contains(fields[j])) {
                tmpRow[fields[j]] = getResourceType(cell)
            }
            else if(mesUnits.contains(fields[j])) {
                tmpRow[fields[j]] = getMesUnits(cell)
            }
            else if(systemType2.contains(fields[j])) {
                tmpRow[fields[j]] = getSystemType2(cell)
            }
            else if(enterDiametr.contains(fields[j])) {
                tmpRow[fields[j]] = getEnterDiametr(cell)
            }
            else if(enterPressure.contains(fields[j])) {
                tmpRow[fields[j]] = getEnterPressure(cell)
            }
            else if(yesNo.contains(fields[j])) {
                tmpRow[fields[j]] = getYesNoField(cell)
            }
            else if(heatingConnection.contains(fields[j])) {
                tmpRow[fields[j]] = getHeatingConnection(cell)
            }
            else if(contractLoad2013.contains(fields[j])) {
                tmpRow[fields[j]] = getContractLoad2013(cell)
            }
            else if(temperatureGrafic.contains(fields[j])) {
                tmpRow[fields[j]] = getTemperatureGrafic(cell)
            }
            else if(heatingGrafic.contains(fields[j])) {
                tmpRow[fields[j]] = getHeatingGrafic(cell)
            }
            else if(heatingScheme.contains(fields[j])) {
                tmpRow[fields[j]] = getHeatingScheme(cell)
            }
            else if(countLiftNodes.contains(fields[j])) {
                tmpRow[fields[j]] = getCountLiftNodes(cell)
            }
            else if(heatingTransit.contains(fields[j])) {
                tmpRow[fields[j]] = getHeatingTransit(cell)
            }
            else if(mrMonth.contains(fields[j])) {
                tmpRow[fields[j]] = getMrMonth(cell)
            }
        }

        parsedSheet[i] = tmpRow

        i++
    }

    parsedSheet
}

def getArrayTE(String fileName, def fields, int sheetNumber)
{
    InputStream inp = new FileInputStream(fileName)

    POIFSFileSystem xssfwb = new POIFSFileSystem(inp)
    HSSFWorkbook wb = new HSSFWorkbook(xssfwb)
    Sheet sheet = wb.getSheetAt(sheetNumber)

    def parsedSheet = parseSheetTE(sheet, fields)

    inp.close()

    parsedSheet
}

def exportExcelTE(def resultArray, def fields) {
    new HSSFWorkbook().with { workbook ->
        def styles = [ LIGHT_BLUE, LIGHT_GREEN, LIGHT_ORANGE ].collect { color ->
            createCellStyle().with { style ->
                fillForegroundColor = color.index
                fillPattern = SOLID_FOREGROUND
                style
            }
        }
        createSheet( 'Output' ).with { sheet ->
            resultArray.each{str ->
                createRow( str.key ).with { row ->
                    int i = 0
                    while (i < fields.size()) {
                        createCell( i ).with { cell ->
                            if(str.value.containsKey(fields[i])) {
                                setCellValue( str.value[fields[i]])
                            }
                            else {
                                setCellValue("")
                            }
                        }
                        i++
                    }
                }
            }
            new File('/tmp/heat.xls').withOutputStream { os ->
                write( os )
            }
        }
    }
}

def parseTESheet(def fileName) {

    def fields = [0:'id_in_file', 1:'bticode', 2:'supplier', 3:'connection_type',
            4:'system_type',5:'consumer', 6:'resource_type', 7:'mes_units',
            8:'number_of_devices', 9:'system_type2', 10:'enter_diametr',
            11:'enter_pressure', 12:'heating_grafic', 13:'gvs_exists', 14:'gvs_necessity',
            15:'system_accounting', 16:'dispatch',17:'heating_connection',18:'gvs_reserv',
            19:'notes', 20:'total_2011', 21:'total_2012', 22:'total_2013_jan', 23:'mr_2013_jan',
            24:'total_2013_feb',25:'mr_2013_feb',26:'total_2013_mar',27:'mr_2013_mar',
            28:'total_2013_apr',29:'mr_2013_apr',30:'total_2013_may',31:'mr_2013_may',
            32:'total_2013_jun',33:'mr_2013_jun',34:'total_2013_jul',
            35:'mr_2013_jul',36:'total_2013_aug', 37:'mr_2013_aug', 38:'total_2013_sep',
            39:'mr_2013_sep', 40:'total_2013_oct', 41:'mr_2013_oct', 42:'total_2013_nov',
            43:'mr_2013_nov', 44:'total_2013_dec', 45:'mr_2013_dec', 46:'total_2013',
            47:'contract_load_2013', 48:'temperature_grafic', 49:'heating_scheme',
            50:'count_lift_nodes', 51:'heating_transit']

    def resultArray = getArrayTE(fileName, fields, 1)

    exportExcelTE(resultArray, fields)
}

parseMKDSheet('Питер/Калининский/Калининский.xls')
parseTESheet('Питер/Калининский/Калининский.xls')

