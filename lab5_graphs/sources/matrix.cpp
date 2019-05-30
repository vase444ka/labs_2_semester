#include "matrix.h"

martix()
{
    edges = 0;
    verts = 0;
}

matrix(int vertices, int cur_edges, int is_multi, int is_oriented, int is_weighed)
{
    srand(time(0));
    verts = vertices;
    edges = cur_edges;
    g = new vector <int>*[verts];

    for (int _i = 0; _i < verts; _i++)
        g[_i] = new vector <int> [verts];

    for (int _i = 0; _i < cur_edges; _i++)
    {
        int weight = 1;
        int from = random()%verts;
        int to = random()%verts;

        if(is_weighed)
            weight = random()%WEIGHT_MAX + 1;

        add_edge(from, to, weight, is_oriented);
    }
}

void print()
{
    for (int from = 0; from < verts; from++)
        for (int to = 0; to < verts; to++)
            for (int edge_ind = 0; edge_ind < g[from][to].size(); edge_ind++)
                cout<<"From: "<<from<<" to: "<<to<<". Weight: "<<g[from][to][edge_ind]<<".\n";
}

void _add_edge(int from, int to, int weight, int is_oriented)
{
    if (from >= verts || to >= verts)
        return;

    g[from][to].push_back(weight);
    if (!is_oriented)
        g[to][from].push_back(weight);
}

void _dfs(int v, int *used)
{
    used[v] = 1;
    for (int _i = 0; _i < verts; _i++)
        if (g[v][_i].size())
            _dfs(_i, used);
}

vector <int> _bfs(int v) //different order
{
    vector <int> bfs_sequence;
    int *used = new int [verts];
    for (int _i = 0; _i < verts; _i++)
        used[_i] = 0;
    queue <int> being_processed;

    being_processed.push(v);
    used[v] = 1;

    while(!being_processed.empty())
    {
        int from = being_processed.front();
        bfs_sequence.push_back(from);

        for (int to = 0; to < verts; to++)
            if (g[from][to].size() && !used[to])
            {
                being_processed.push(to);
                used[to] = 1;
            }

        being_processed.pop();
    }

    return bfs_sequence;
}

int minimal(vector <int> &multiple_edges){
    int min_edge = WEIGHT_MAX + 1;
    for (int _i = 0; _i < multiple_edges.size(); _i++)
        min_edge = std::min(min_edge, multiple_edges[_i]);
    return min_edge;
}

int** matrix::_floyd(){
    int** dist = new int*[verts];
    for (int _i = 0; _i < verts; _i++){
        dist[_i] = new int[verts];
        for (int _j = 0; _j < verts; _j++)
            if (_i == _j)
                dist[_i][_j] = 0;
            else if (g[_i][_j].size() == 0)
                dist[_i][_j] = INF;
            else
                dist[_i][_j] = minimal(g[_i][_j]);
    }

    for (int via = 0; via < verts; via++)
        for (int from = 0; from < verts; from++)
            for (int to = 0; to < verts; to++)
                dist[from][to] = std::min(dist[from][to], dist[from][via] + dist[via][to]);

    return dist;
}
