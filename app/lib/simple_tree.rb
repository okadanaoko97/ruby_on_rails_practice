class SimpleTree
  attr_reader :root, :nodes

  def initialize(root, descendants)
    @root = root
    @descendants = descendants

    @nodes = {}                                   #ノードのIDをキーとして、対応するノードオブジェクトを値として保持
    ([ @root ] + @descendants).each do |d|
      d.child_nodes = []
      @nodes[d.id] = d                           #ノードのIDをキーとしてノードオブジェクトを@nodesハッシュに格納
    end

    @descendants.each do |d|
      @nodes[d.parent_id].child_nodes << @nodes[d.id]
    end
  end
end
