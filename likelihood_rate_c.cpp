#include "mex.h"
#include "math.h"
#include "stdio.h"
#include "stdlib.h"//free
#define N 2048//信息比特长度
#define K 1024//信息比特长度
#define L 1
char sign(double x)//判断符号函数
{
	char z;
	if (x>0)
		z=1;
	else if (x<0)
		z=-1;
	else
		z=0;
	return(z);
}
double min(double a,double b)//取较小值函数
{
	if (a>=b)
		return b;
	else
		return a;
}
double likelihood_rate_c(int n,int i,char *uu,double*LLR_matrix)//求似然比函数
{
	int j,k=0,k1=0;
	double LLR=0,L1=0,L2=0;
	double LLR_matrix1[K],LLR_matrix2[K];
    char ue[K],uo[K],uoe[K];
	if (n!=1)
	{
		if (i&1==1)//jishu//
		{
			for(j=0;j<i-1;j=j+2,k++) //
			{
				uo[k]=uu[j];
				ue[k]=uu[j+1];
				uoe[k]=(uo[k]+ue[k])&1;//
			}
			for(j=0;j<n/2;j++,k1++) //
			{
				LLR_matrix1[k1]=LLR_matrix[j];
				LLR_matrix2[k1]=LLR_matrix[n/2+j];
			}
			L1=likelihood_rate_c(n/2,(i+1)/2,uoe,LLR_matrix1);
			L2=likelihood_rate_c(n/2,(i+1)/2,ue,LLR_matrix2);
			LLR=sign(L1*L2)*min(fabs(L1),fabs(L2));
		}
		else  //oushu
		{
			for(j=0;j<i-2;j=j+2,k++) //
			{
				uo[k]=uu[j];
				ue[k]=uu[j+1];
				uoe[k]=(uo[k]+ue[k])&1;///
			}
			for (j=0;j<n/2;j++,k1++) //
			{
				LLR_matrix1[k1]=LLR_matrix[j];
				LLR_matrix2[k1]=LLR_matrix[n/2+j];
			}
			L1=likelihood_rate_c(n/2,i/2,uoe,LLR_matrix1);
			L2=likelihood_rate_c(n/2,i/2,ue,LLR_matrix2);
			LLR=(1-2*uu[i-2])*L1+L2;//pow((double)-1,)
		}
        return LLR;
	}
    else
	{
		LLR=LLR_matrix[0];
		return LLR;
	}
}
//***********************************************************
void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray*prhs[])
{
	int n=(int)mxGetScalar(prhs[0]);       //标量 整型
	int i=(int)mxGetScalar(prhs[1]);       //
	double*uu=mxGetPr(prhs[2]);     //矢量 double型
	double*LLR_matrix=mxGetPr(prhs[3]); 
	double*LLR;
	int k=0;
	char *int_uu;
	int_uu=(char*)malloc(sizeof(char)*(i-1));//double转换成int
	for(k=0;k<i-1;k++)
	{
		int_uu[k]=(char)uu[k];
	}
	plhs[0]=mxCreateDoubleMatrix(1,1,mxREAL);//需要在mex函数内申请到内存空间
	LLR=mxGetPr(plhs[0]);
	*LLR=likelihood_rate_c(N,i,int_uu,LLR_matrix);
	free(int_uu);
	int_uu=NULL;
	return;
}



