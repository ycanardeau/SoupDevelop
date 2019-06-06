
#module mod_TreeContent children, content

#modfunc TreeContentSetContent str _content
	content = _content
	return

#modinit str _content, local thisID
	mref thisID, 2
	TreeContentSetContent thismod, _content
	dimtype children, 5, 1
	return thisID

#deffunc _TreeContentNew array tree, str _content
#define global TreeContentNew( %1, %2 = "" ) _TreeContentNew %1,%2
	newmod tree, mod_TreeContent, _content
	return stat

#modcfunc TreeContentGetContent
	return content

#modcfunc TreeContentGetNumChildren
	return length( children )

#modfunc TreeContentGetChild int index, var result
	if( index < 0 || index >= length( children ) ) : return 1
	if( varuse( children.index ) == 0 ) : return 1
	result = children.index
	return 0

#modfunc TreeContentAddChild var child
	TreeContentNew children
	children.stat = child
	return

#modfunc _TreeContentShow str indent
#define global TreeContentShow( %1, %2 = "" ) _TreeContentShow %1, %2
	mes indent + content
	foreach children
		if( varuse( children.cnt ) ) {
			TreeContentShow children.cnt, indent + "  "
		}
	loop
	return

#modfunc _TreeContentDeepClone var src, local src_child
	TreeContentSetContent thismod, TreeContentGetContent( src )

	repeat TreeContentGetNumChildren( src )
		TreeContentGetChild src, cnt, src_child
		if stat : continue
		TreeContentNew children, TreeContentGetContent( src_child )

		_TreeContentDeepClone children.stat, src_child
	loop
	return

#deffunc TreeContentDeepClone array dest, var src
	TreeContentNew dest
	_TreeContentDeepClone dest.stat, src
	return

#global

#if 0

#include "TreeView.as"

	TreeContentNew tree, "root"

		TreeContentNew tree_1, "1"
		TreeContentAddChild tree, tree_1

		TreeContentNew tree_2, "2"
		TreeContentAddChild tree, tree_2

			TreeContentNew tree_2_1, "2-1"
			TreeContentAddChild tree_2, tree_2_1

				TreeContentNew tree_2_1_1, "2-1-1"
				TreeContentAddChild tree_2_1, tree_2_1_1

			TreeContentNew tree_2_2, "2-2"
			TreeContentAddChild tree_2, tree_2_2

	cls 1
	newmod treeView, mod_TreeView, 0, 0x0001 | 0x0002 | 0x0200, 0, 0, 100, ginfo_winy
	addNode treeView, tree, 0

	pos 100, 0
	TreeContentShow tree
	
	stop
	
#deffunc addNode var _treeView, var _node, int _hParent,\
	local node, local hNode
	
	node = _node
	hNode = TreeViewInsertItem(_treeView, _hParent, TVI_LAST, 0, TreeContentGetContent(node), 0)
	
	repeat TreeContentGetNumChildren(node)
		TreeContentGetChild node, cnt, child
		if (stat != 0) {
			continue
		}
		addNode _treeView, child, hNode
	loop
	return

#endif