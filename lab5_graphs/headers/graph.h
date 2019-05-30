#ifndef GRAPH_H_INCLUDED
#define GRAPH_H_INCLUDED

template <class T> class graph : T{//oriented weighed multigraph ++ implement transition
public:
    void add_edge(int from, int to, int weight = 1, int is_oriented = 0){
        this->_add_edge(from, to, weight, is_oriented);
    }

    void print(){
        this->_print();
    }

    int components(){
        int cnt = 0;
        int *used = new int[verts];
        for (int _i = 0; _i<verts; _i++)
            used[_i] = 0;

        for (int _i = 0; _i<verts; _i++)
            if (!used[_i]){
                this->_dfs(_i, used);
                cnt++;
            }
        delete used;

        return cnt;
    }

    vector <int> bfs(int v){
        this->_bfs(v);
    }

    int* dijikstra(int v){//d[i] = dist to i vertex
        return this->_dijikstra(v);
    }

    int** floyd(){
        return this->_floyd();
    }

    void toposort(){
        this->_toposort();
    }

    //ostov tree
};

#endif // GRAPH_H_INCLUDED
