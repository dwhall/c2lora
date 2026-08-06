import std/[sets, strutils]

type Edge = tuple[src: string, dst: string]

iterator compactLines(f: File, nodeSet: var HashSet[Edge]): string =
  func isEdge(line: string): bool =
    line.startsWith('"') and line.contains("\" -> \"") and line.endsWith("\";")

  func compactNode(node: string): string =
    #!fmt: off
    const truncationTable = [
      ("std/", "std"),
      ("pkg/pathX", "pkg/pathX"),
      ("system/", "system"),
      ("/C/Users/halld/.choosenim/toolchains/nim-2.2.10", "nim-2.2.10"),
    ]
    #!fmt: on
    for (prefix, replacement) in truncationTable:
      if node.startsWith(prefix):
        return replacement
    const replacementTable = [
      ("../deps/krnl/src/krnlpkg", "krnlpkg"),
      ("../deps/krnl/deps", "deps"),
      ("../deps", "deps"),
    ]
    #!fmt: on
    for (prefix, replacement) in replacementTable:
      if node.startsWith(prefix):
        return node.replace(prefix, replacement)
    node

  func compactLine(line: string, nodeSet: var HashSet[Edge]): string =
    let
      parts = line.split("\" -> \"")
      srcNode = compactNode(parts[0].strip(chars = {'"'}))
      dstNode = compactNode(parts[1].strip(chars = {'"', ';'}))
    if srcNode == dstNode:
      return ""
    let edge = (src: srcNode, dst: dstNode)
    if edge in nodeSet:
      return ""
    nodeSet.incl(edge)
    '"' & srcNode & "\" -> \"" & dstNode & "\";\p"

  for line in f.lines:
    if isEdge(line):
      yield compactLine(line, nodeSet)
    else:
      yield line & "\p"

proc main() =
  var nodeSet: HashSet[Edge]
  nodeSet.init
  for line in compactLines(stdin, nodeSet):
    stdout.write(line)

when isMainModule:
  main()
