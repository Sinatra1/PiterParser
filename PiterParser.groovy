
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

def getUnsignedIntField(def cell) {

    def intValue = ""
    if(cell.cellType == Cell.CELL_TYPE_NUMERIC) {
        intValue =  cell.getNumericCellValue() as int
    }

    intValue
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



def parseSheet(Sheet sheetMKD, fields) {
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

def getArray(String fileName, def fields, int sheetNumber)
{
    InputStream inp = new FileInputStream(fileName)

    POIFSFileSystem xssfwb = new POIFSFileSystem(inp)
    HSSFWorkbook wb = new HSSFWorkbook(xssfwb)
    Sheet sheet = wb.getSheetAt(sheetNumber)

    def parsedSheet = parseSheet(sheet, fields)

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

    def resultArray = getArray(fileName, fields, 0)

    exportExcelMKD(resultArray, fields)
}

parseMKDSheet('Питер/Калининский/Калининский.xls')

