
#ifndef mod_TSVDataBase
	
#module mod_TSVDataBase
	
	#defcfunc TSVDataBaseGetData var _buffer, int _row,\
		local data
		
		notesel _buffer
		noteget data, _row
		noteunsel
		return data
	
	#deffunc TSVDataBaseSetData var _buffer, int _row, str _data
		notesel _buffer
		if (_row > notemax) {
			repeat _row - notemax
				noteadd "", -1
			loop
		}
		noteadd _data, _row, 1
		noteunsel
		return
	
	#defcfunc TSVDataBaseGetCellData var _buffer, int _row, int _column,\
		local data, local cellData
		
		notesel _buffer
		noteget data, _row
		split data, "\t", cellData
		if (_column >= stat) {
			return ""
		}
		noteunsel
		return cellData(_column)
	
	#deffunc TSVDataBaseSetCellData var _buffer, int _row, int _column, str _cellData,\
		local data,\
		local columns
	
		sdim data
		columns = TSVDataBaseGetColumns(_buffer, _row)
		if ((_column + 1) > columns) {
			columns = _column + 1
		}
		repeat columns
			if (cnt != 0) {
				data += "\t"
			}
			if (_column == cnt) {
				data += _cellData
			} else {
				data += TSVDataBaseGetCellData(_buffer, _row, cnt)
			}
		loop
		TSVDataBaseSetData _buffer, _row, data
		return
	
	#defcfunc TSVDataBaseGetRows var _buffer,\
		local rows
		
		notesel _buffer
		rows = notemax
		noteunsel
		return rows
	
	#defcfunc TSVDataBaseGetColumns var _buffer, int _row,\
		local data, local cellData,\
		local columns
	
		data = TSVDataBaseGetData(_buffer, _row)
		split data, "\t", cellData
		columns = stat
		return columns
	
	#defcfunc TSVDataBaseGet var _buffer
		return _buffer
	
	#deffunc TSVDataBaseSet var _buffer, str _data
		_buffer = _data
		return
	
#global
	
#if 0
	
	dimtype tsvDataBase, 5
	newmod tsvDataBase, mod_TSVDataBase
	newmod tsvDataBase, mod_TSVDataBase
	TSVDataBaseSetData tsvDataBase(0), 0, "(0, 0)\t(0, 1)\t(0, 2)"
	TSVDataBaseSetData tsvDataBase(0), 1, "(1, 0)\t(1, 1)\t(1, 2)"
	TSVDataBaseSetData tsvDataBase(0), 2, "(2, 0)\t(2, 1)\t(2, 2)"
	TSVDataBaseCopy tsvDataBase(0), tsvDataBase(1)
	mes TSVDataBaseGetData(tsvDataBase(1), 0)
	TSVDataBaseSetCellData tsvDataBase(1), 1, 1, "(?, ?)"
	mes TSVDataBaseGetCellData(tsvDataBase(1), 1, 1)
	stop
	
#endif
	
#endif
