#ifndef MATRIX_H_INCLUDED
#define MATRIX_H_INCLUDED

#include <vector>
#include <time.h>
#include <queue>

const int WEIGHT_MAX = 10;
const int INF = 1000000007;

class matrix{
    vector <int> **g;
    int edges, verts;
public:
    martix();
    matrix(int vertices, int cur_edges, int is_multi, int is_oriented, int is_weighed);
    void print();
    void _add_edge(int from, int to, int weight, int is_oriented);
    void _dfs(int v, int *used);
    vector <int> _bfs(int v); //order

    int* _dijikstra(int v){
        int *dist = new int[verts];
    }

    int** _floyd();

    //toposort+ostov

};


#endif // MATRIX_H_INCLUDED
