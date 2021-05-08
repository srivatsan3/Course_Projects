#include <iostream>
#include <thread>
#include <queue>
#include <semaphore.h>
#include <limits.h>
#include <bits/stdc++.h>
#include <sys/time.h>
#include <chrono>
#include <random>
using namespace std;

struct timeval start_time,end_time;
struct vertices
{
  int id;
  int color;
};
sem_t *mutex_lock_ptr;
bool *part_mat_ptr;
bool *adj_mat_ptr;

class compare
{
public:
    bool operator() (struct vertices a1, struct vertices a2)
    {
      if(a1.id > a2.id)
        return true;
      return false;
    }
};

/*void showpq(priority_queue<struct vertices, vector<struct vertices>, compare > pq)
{
    priority_queue<struct vertices, vector<struct vertices>, compare > g = pq;
    while (!g.empty()) {
        cout << '\t' << g.top().id;
        g.pop();
    }
    cout << '\n';
}*/

bool exist(priority_queue<struct vertices, vector<struct vertices>, compare > pq, int id)
{
    priority_queue<struct vertices, vector<struct vertices>, compare > g = pq;
    while (!g.empty()) {
        if(g.top().id == id)
          return true;
        g.pop();
    }
    return false;
}

void coloring(priority_queue<struct vertices, vector<struct vertices>, compare> B,int n,int m, int index,struct vertices* v)
{
  int totalcolors[m+1];
  bool arr[n];
  for(int i=0;i<n;i++)
  {
    arr[i] = part_mat_ptr[index*n+i];
  } 
  for(int i=0;i<m+1;i++)
    totalcolors[i] = i;
  /*for(int i=0;i<n;i++)
    cout<<arr[i]<<" "<<std::flush;
  cout<<endl<<std::flush;*/
  for(int i=0;i<n;i++)
  {
    if(arr[i] == 1 && !exist(B,i))
    {
      int colors[m+1];
      for(int k=0;k<m+1;k++)
      {
        colors[k] = totalcolors[k];
      }
      for(int j=0;j<n;j++)
      {
        if(adj_mat_ptr[i*n+j] == 1)
        {
          colors[v[j].color] = INT_MAX;
        }
      }
      v[i].color = *min_element(colors, colors+m+1);
    }
    else if(arr[i] == 1 && exist(B,i))
    {
      priority_queue<struct vertices,vector<struct vertices>,compare> A;
      for(int j=0;j<n;j++)
      {
        if(adj_mat_ptr[i*n+j] == 1)
        {
          A.push(v[j]);
        }
      }
      A.push(v[i]); 
      priority_queue<struct vertices,vector<struct vertices>,compare> A_temp;
      A_temp = A;
      int size = A.size();
      for(int k=0;k<size;k++)
      {
        sem_wait(&mutex_lock_ptr[A_temp.top().id]);
        A_temp.pop();
      }
      int colors[m+1];
      for(int k=0;k<m+1;k++)
      {
        colors[k] = totalcolors[k];
      }
      for(int j=0;j<n;j++)
      {
        if(adj_mat_ptr[i*n+j] == 1)
        {
          colors[v[j].color] = INT_MAX;
        }
      }
      v[i].color = *min_element(colors, colors+m+1);
      A_temp = A;
      for(int k=0;k<size;k++)
      {
        sem_post(&mutex_lock_ptr[A_temp.top().id]);
        A_temp.pop();
      }
    }
  }
}

int main() 
{
  int n;

  int p;

  ifstream iptr("input_params.txt");
  ofstream optr("output.txt");
  iptr>>p;
  iptr>>n;
  int seed = chrono::system_clock::now().time_since_epoch().count();
  sem_t mutex_locks[n];
  int m=0;
  int temp;
  for(int i=0;i<n;i++)
  {
    iptr>>temp;
  }
  mutex_lock_ptr = mutex_locks;
  bool *adj_mat = (bool*)malloc(n*n*sizeof (bool));
  bool *part_mat = (bool*)malloc(p*n*sizeof(bool));
  adj_mat_ptr = adj_mat;
  part_mat_ptr = part_mat;

  struct vertices v[n];
  
  for(int i=0;i<n;i++)
  {
    v[i].id = i;
    v[i].color = -1;
    sem_init(&mutex_locks[i],0,1);
  }

  for(int i=0;i<n;i++)
  {
    iptr>>temp;
    for(int j=0;j<n;j++)
      iptr>>adj_mat[i*n+j];
  }

  thread threads[p];

  int partition[n];
  for(int i=0;i<n;i++)
    partition[i] = -1;

  for(int i=0;i<p;i++)
  {
    int random = rand()%n;
    if(partition[random] == -1)
      partition[random] = i;
    else
      i--;
  }

  for(int i=0;i<n;i++)
    if(partition[i] == -1)
      partition[i] = rand()%p;

  /*for(int i=0;i<n;i++)
  {
    for(int j=0;j<n;j++)
      cout<<adj_mat[i*n+j]<<" "<<std::flush;
    cout<<endl;
  }*/
  for(int i=0;i<n;i++)
  {
    int count_ones = 0;
    for(int j=0;j<n;j++)
    {
      if(adj_mat[i*n+j] == 1)
        count_ones = count_ones+1;
    }
    if(count_ones>m)
      m = count_ones;
  }
  /*cout<<"Partition \n";
  for(int i=0;i<n;i++)
    cout<<partition[i]<<" ";*/

  priority_queue<struct vertices, vector<struct vertices>, compare > PQ;
  for(int i=0;i<n;i++)
  {
    for(int j=0;j<n;j++)
    {
      if(adj_mat[i*n+j] == 1 && partition[i]!=partition[j] && !exist(PQ,i))
      {
        PQ.push(v[i]);
        break;
      }
    }
  }
  //showpq(PQ);
  for(int i=0;i<p;i++)
  {
    for(int j=0;j<n;j++)
    {
      if(partition[j] == i)
        part_mat[i*n+j] = 1;
      else
        part_mat[i*n+j] = 0;
    }
  }
  //cout<<endl;
  /*for(int i=0;i<p;i++)
  {
    for(int j=0;j<n;j++)
      cout<<part_mat[i*n+j]<<" ";
    cout<<endl;
  }*/
  gettimeofday(&start_time,NULL);
  for(int i=0;i<p;i++)
  {
    threads[i] = thread(coloring,PQ,n,m,i,(struct vertices *)v);
  }
  
  for(int i=0;i<p;i++)
  {
    threads[i].join();
  }
  gettimeofday(&end_time,NULL);

  int color_array[n];
  for(int i=0;i<n;i++)
    color_array[i] = v[i].color;

  cout<<"Number of colors used: "<<*max_element(color_array,color_array+n)+1<<endl;
  cout<<"Total time taken in (ms): "<<((end_time.tv_usec-start_time.tv_usec)/1000.0)+((end_time.tv_sec-start_time.tv_sec)*1000)<<endl;
  
  /*cout<<"Colors :"<<endl;
  for(int i=0;i<n;i++)
    cout<<"v"<<i<<" - "<<v[i].color<<", ";*/

  cout<<endl;

  optr<<"Number of colors used: "<<*max_element(color_array,color_array+n)+1<<endl;
  optr<<"Total time taken in (ms): "<<((end_time.tv_usec-start_time.tv_usec)/1000.0)+((end_time.tv_sec-start_time.tv_sec)*1000)<<endl;
  
  optr<<"Colors :"<<endl;
  for(int i=0;i<n;i++)
    optr<<"v"<<i<<" - "<<v[i].color<<", ";

    optr<<endl;
}