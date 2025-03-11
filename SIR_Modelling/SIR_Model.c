#include<stdio.h>		// Preprocesser library for C
#include<stdlib.h>	   	// Library for malloc and free
#include<time.h>		// Library for time stamp to run srand


#define MAX_VERTICES 10000		//Define max_vertices
#define MAX_EDGES 3000			//Define max_edges
float tau = 0.5;				//Transmission rate tau
float gama = 0.2;				//Recovery rate gamma
int tmax  = 300;				//Tmax for 300 days
int k=0;						//Global variable for array indicing
int times[MAX_VERTICES] ={0};	//Array to store times
int Slist[MAX_VERTICES] ={0};	//Array to store No of people suscepted at some time
int Rlist[MAX_VERTICES] = {0};	//Array to store No of people recovered at some time
int Ilist[MAX_VERTICES] = {0};	//Array to store No of people infected at some time
char node_array[MAX_VERTICES];	//Array to store if a node is 'S' or 'I' or 'R'

typedef unsigned char vertex;	//Unsigned char vertex

struct PQ						//Priority Queue struct
{
	unsigned char **node;		//Unsigned char pointer to Node of graph
	int person;					//Int to store person number
	char action;				//Char to store action ('T' for transmit,'R' for recover)
	int time;					//int to store time of event 
	struct PQ* next;			//Pointer to next 
	struct PQ* prev;			//Pointer to prev
}; 
struct PQ* head = NULL;			//Head pointer to priority Queue

void push(struct PQ** headref, struct PQ* na, char eve, unsigned char** node_num, int tym,int per) //Function to push an event on Priority Queue
{
	struct PQ* new_node = NULL;								//Newnode
	new_node = (struct PQ*)malloc(sizeof(struct PQ));		//Newnode memory allocation
	new_node->action = eve;									//Assigning values to struct data
	new_node->node= node_num;
	new_node->time = tym;
	new_node->person = per;
	
	if(na == NULL)						//If head NULL
	{
		new_node->next = NULL;			//Make newnode's next and prev NULL
		new_node->prev = NULL;
		*headref = new_node;			//Make new node as head
		return;
	}
	while(na->time < new_node->time  && na->next!=NULL) 	//As long as priority of elements are larger than incoming node priority,keep traversing
		na=na->next;
	if(na->next == NULL)						//If last node reached
	{
		if(na->time < new_node->time)			//Compare if newnode's time is smaller than current node's
		{
			new_node->prev = na;				//Insert new_node at end
			na->next = new_node;
			new_node->next = NULL;
		}
		else 									//If last node has lesser priority compared to incoming node
		{
			new_node->next = na;				//Insert newnode right before the last node
			if(na->prev != NULL)
				na->prev->next = new_node;
			else
				*headref = new_node;
			new_node->prev = na->prev;
			na->prev = new_node;
		}
	}
	else if(na->next != NULL)				//If the node with lesser priority than incoming node is not the last node
	{
		new_node->next = na;				//Insert it before that node
		if(na->prev != NULL)
			na->prev->next = new_node;
		else
			*headref = new_node;
		new_node->prev = na->prev;
		na->prev = new_node;
	}
	return;
}
	
void pop(struct PQ** headref, struct PQ* na)		//Function to remove the topmost element
{
	if( na== NULL)									//If Queue empty,return 
		return;
	*headref = na->next;							//Make the next of newnode as head
	free(na);										//free the topmost node
	return;
}

struct PQ* topmost(struct PQ* na)					//Function to return the topmost node
{
	if(na == NULL)
		return NULL;								//If Queue empty,return NULL
	return (na);									//Else return topmost node
}

void printPQ(struct PQ* na)							//Function to print Priority Queue
{
	if(na == NULL)									//If Queue empty
	{
		printf("Queue Empty\n");
		return;
	}
	while(1)										//Else keep printing until end
	{
		printf("TIME: %d ACTION: %c PERSON: %d\n",na->time, na->action,na->person); //Print details 
		na= na->next;	//Traverse to next node
		if(na == NULL)	//If last reached, break out
			break;
	}
	puts("");
}

int minimum(int a,int b,int c)  //Function to return minimum of given 3 numbers
{
	if(a<b && a<c)			//If a is less than both b,c then return a
		return a;
	else if(b<c)			//Else if b is less than c,return b
		return b;
	else
		return c;			//Else return c
}
void process_trans_SIR(int num,unsigned char** nodenum,int event_time,int per,int inf[],int rec_t[],int inf_t[])  //Function to process transmission of SIR
{
	Slist[0] = num;		//Initial Susceptibles are total vertices
	srand(time(0));		//Randomize from time stamp
	int t = event_time;	//Store event_time
	int trans = 0;		//Variable to tell after how many days transmit event will occur
	int rec = 0;		//Variable to tell after how many days recover event will occur
	times[k+1] = t; 	//Update times
	Slist[k+1] = Slist[k] - 1;	//Update Susceptible list
	Ilist[k+1] = Ilist[k] + 1;	//Update Infected list
	Rlist[k+1] = Rlist[k];		//Update Recovered list
	
	node_array[per] = 'I';		//Make the node status as infected
	while(1)
	{
		rec++;		//Count number of days it took for a head
		int toss_rec = rand()%((int)(1/gama));	//Randomly choose a number out of 5
		if(toss_rec == 0)	//If one of the possibility( with 20% probability occurs),then break out
			break;
	}
	rec_t[per] = t+rec;	//Add the number of days it will take to recover to the event_time and store in a recovered time lists
	if(rec_t[per] < tmax)	//If the recovery occurs before the maximum time
	{
		push(&head,head,'R',nodenum,rec_t[per],per);	//Push an recover event to Priority Queue
	}
	
	for(int i=0;i<num;i++)				//For all the nodes
	{
		if(nodenum[per][i] >=0  && node_array[i] == 'S') //If the source node is connected to it and the taget node is susceptible
		{
			while(1)
			{
				int toss = rand()%((int)(1/tau));				//Randomly choose 1 number out of 2
				trans++;										//Count the number of days it took for a head
				if(toss == 1)									//If one of the possibility(with 50% probability occurs),then break out
					break;
			}
			inf_t[i] = t+trans;						//Make the infected time of that person as event_time+ no of days it took to get infected
			if(inf_t[i] < minimum(rec_t[per],tmax,inf[i]))	//If infected time is less than, (Source's recover time, Tmax, and predicted infected time for node)
			{
				push(&head,head,'T',&nodenum[i],inf_t[i],i);	//Push a transmit event to Priority Queue
				inf[i] = inf_t[i];								//Change the predicted infection time to currently infected time
				node_array[i] = 'I';							//Make the status of Infected node as I			
			}
		}
	}
	k= k+1;		//Add the index by 1
}

void process_rec_SIR(int num,unsigned char** nodenum, int node_time,int per,int inf[]) //Function to process recovery
{
	times[k+1] = node_time;	//Update times by node_time
	Slist[k+1] = Slist[k];	//Slist remains same
	Ilist[k+1] = Ilist[k]-1;//Infected number goes down by 1
	Rlist[k+1] = Rlist[k]+1;//Recovered number goes up by 1
	
	node_array[per] = 'R';	//Make the status of Recovered node as R
	k=k+1;
}

int main(){
	
    srand ( time(0) );									//Randomizing using timestamp
    int numberOfVertices = rand() % MAX_VERTICES;		//Randomly choosing a number of vertices
 
    srand ( time(NULL) );
    int maxNumberOfEdges = rand() % MAX_EDGES;			//Randomly choosing a number of Edges
  
    if( numberOfVertices == 0)							//Making sure atleast 1 vertex exists
        numberOfVertices++;	
    vertex ***graph;									//vertex triple pointer GRAPH
    printf("Total Vertices = %d, Max # of Edges = %d\n",numberOfVertices, maxNumberOfEdges);
	
    if ((graph = (vertex ***) malloc(sizeof(vertex **) * numberOfVertices)) == NULL) //If memory unallocatable
    {
        printf("Could not allocate memory for graph\n");
        exit(1);
    }
	
    int vertexCounter = 0;
    int edgeCounter = 0;
 
    for (vertexCounter = 0; vertexCounter < numberOfVertices; vertexCounter++){	//If memory unallocatable,iterated on vertices and edges
        if ((graph[vertexCounter] = (vertex **) malloc(sizeof(vertex *) * maxNumberOfEdges)) == NULL){
            printf("Could not allocate memory for edges\n");
            exit(1);
        }
        for (edgeCounter = 0; edgeCounter < maxNumberOfEdges; edgeCounter++){
            if ((graph[vertexCounter][edgeCounter] = (vertex *) malloc(sizeof(vertex))) == NULL){
                printf("Could not allocate memory for vertex\n");
                exit(1);
            }
        }
    }
	

    vertexCounter = 0;edgeCounter = 0;
    for (vertexCounter = 0; vertexCounter < numberOfVertices; vertexCounter++){	//Looping for each vertex
       // printf("%d:\t",vertexCounter);
        for (edgeCounter=0; edgeCounter < maxNumberOfEdges; edgeCounter++){		//Looping for the maximum number of edges a vertex can have
            if (rand()%2 == 1){ //link the vertices	
                int linkedVertex = rand() % numberOfVertices;			//Linked vertex is chosen randomly
                graph[vertexCounter][edgeCounter] = graph[linkedVertex];	//Linking vertex
               // printf("%d, ", linkedVertex);
            }
            else{ 
                graph[vertexCounter][edgeCounter] = NULL;			//If not linked,make link NULL
                
            }
        }
       // printf("\n");
    }
    
   unsigned char **node_num[numberOfVertices] ;	//An unsigned char to indicing all the graph nodes in order
	
	for(int i=0;i<numberOfVertices;i++)		//Indicing all the vertices appropriately
		node_num[i] = graph[i];
		
	int pred_inf[numberOfVertices];		//Array for pred_inf_time
	int inf_time[numberOfVertices];		//Array for infected time
	for(int i=0;i<MAX_VERTICES;i++)		//For all vertices
		node_array[i] = 'X';
	
	for(int i=0;i<numberOfVertices;i++)	//For all vertices,make pred_inf large,nodes susceptible
	{
		pred_inf[i] = 10000;
		node_array[i] = 'S';
	}
	Slist[0] = numberOfVertices;		//Initialize Slist with total number of nodes

	for(int i=0;i<((int)(0.1*MAX_VERTICES));i++)	//Randomly infect 10% of people
	{
		int randnode = rand()%numberOfVertices+1;	//Randomly chose a vertex
		push(&head,head,'T',node_num[randnode],0,randnode);	//Push a transmit event for them
		pred_inf[randnode] = 0;		//their pred_inf time to initial time 0
	}
	int rec_time[numberOfVertices];		//Array for recovered time
	k=0;
		while( topmost(head) != NULL)	//As long as Queue is not empty
		{			
			struct PQ* event = topmost(head);	//Event is the topmost entry in Priority Queue
			if(event->action == 'T')			//If event's action is transmit
			{
				if(node_array[event->person] == 'S')	//If person susceptible
					process_trans_SIR(numberOfVertices,event->node,event->time,event->person,pred_inf,rec_time,inf_time);//Call process_trans_SIR
			}
			else 	//Else call process_rec_SIR
				process_rec_SIR(numberOfVertices,event->node,event->time,event->person,pred_inf);
			pop(&head,head); 		//Pop the top event
		}
		
	printf("\nInitial: \nSusceptibles:%d ,Infected: %d , Recovered : %d\n",Slist[0],Ilist[0],Rlist[0]);//Print intital no of SIR people
	printf("\nFinal: \nSusceptibles:%d ,Infected: %d , Recovered : %d\n",Slist[k],Ilist[k],Rlist[k]);//Print final no of SIR people
	
	//printf("\n%d %d\n",numberOfVertices,maxNumberOfEdges);
    return 1;
}

