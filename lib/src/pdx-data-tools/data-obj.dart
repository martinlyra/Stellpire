
// TODO: Evaluate the fate of this code

class Node
{
  String name;

  Node parent;
  List<Node> children;

  Node(String name)
  {
    this.name = name;
    children = new List();
  }

  void addNodes(List<Node> nodes)
  {
    for (Node node in nodes)
      addNode(node);
  }

  void addNode(Node node)
  {
    if (node.parent != null) {
      if (node.parent == this)
        return;
      else
        node.parent.children.remove(node);
    }
    node.parent = this;
    children.add(node);
  }

  String toString()
  {
    String out = "${name}: [";
    if (children.isNotEmpty)
      out += "\n";
    for (Node child in children) {
      var lines = child.toString().split("\n");
      for (var line in lines)
        out += "\t${line}\n";
    }
    return out += "]";
  }
}

class PropertyNode<T> extends Node
{
  T value;

  PropertyNode(String name, T value) : super(name){
    this.value = value;
  }

  String toString()
  {
    return "${name}: ${value}";
  }
}