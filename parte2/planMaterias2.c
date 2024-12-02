#include <stdio.h>
#include <semaphore.h>
#include <pthread.h>

sem_t IP,F1,M1,ED, M2, F2, PA, BDD, IS, RC, IA, AA, CG, RO, SO, SI, DW, SD, BD, CS;

void print(char x[])
{
    printf("Materia: %s\n", x);
}

void *pIP(void *x)
{
    print("IP");
    sem_post(&IP);
    return NULL;
}

void *pM1(void *x)
{
    print("M1");
    sem_post(&M1);
    return NULL;
}

void *pF1(void *x)
{
    print("F1");
    sem_post(&F1);
    return NULL;
}

void *pED(void *x)
{
    sem_wait(&IP);
    print("ED");
    sem_post(&ED);
    return NULL;
}

void *pM2(void *x)
{
    sem_wait(&M1);
    print("M2");
    sem_post(&M2);
    return NULL;
}

void *pF2(void *x)
{
    sem_wait(&F1);
    print("F2");
    sem_post(&F2);
    return NULL;
}

void *pPA(void *x)
{
    sem_wait(&ED);
    sem_wait(&M2);
    print("PA");
    sem_post(&PA);
    return NULL;
}

void *pBDD(void *x)
{
    sem_wait(&F2);
    print("BDD");
    sem_post(&BDD);
    return NULL;
}

void *pRC(void *x)
{
    sem_wait(&F2);
    sem_wait(&PA);
    print("RC");
    sem_post(&RC);
    return NULL;
}

void *pIS(void *x)
{
    sem_wait(&PA);
    print("IS");
    return NULL;
}

void *pIA(void *x)
{
    sem_wait(&PA);
    sem_wait(&M2);
    print("IA");
    return NULL;
}

void *pAA(void *x)
{
    sem_wait(&PA);
    sem_wait(&M2);
    print("AA");
    return NULL;
}

void *pCG(void *x)
{
    sem_wait(&PA);
    sem_wait(&F2);
    print("CG");
    return NULL;
}

void *pRO(void *x)
{
    sem_wait(&PA);
    sem_wait(&F2);
    print("RO");
    return NULL;
}

void *pSO(void *x)
{
    sem_wait(&RC);
    sem_wait(&PA);
    print("SO");
    sem_post(&SO);
    return NULL;
}

void *pSI(void *x)
{
    sem_wait(&BDD);
    sem_wait(&RC);
    print("SI");
    sem_post(&SI);
    return NULL;
}

void *pDW(void *x)
{
    sem_wait(&BDD);
    sem_wait(&RC);
    print("DW");
    return NULL;
}

void *pSD(void *x)
{
    sem_wait(&SO);
    sem_wait(&RC);
    print("SD");
    return NULL;
}

void *pBD(void *x)
{
    sem_wait(&BDD);
    sem_wait(&M2);
    print("BD");
    return NULL;
}

void *pCS(void *x)
{
    sem_wait(&SI);
    sem_wait(&SO);
    print("CS");
    return NULL;
}

int main()
{
    // Inicializacion semaforos
    sem_init(&IP, 0, 0);
    sem_init(&M1, 0, 0);
    sem_init(&F1, 0, 0);
    sem_init(&ED, 0, 0);
    sem_init(&M2, 0, 0);
    sem_init(&F2, 0, 0);
    sem_init(&PA, 0, 0);
    sem_init(&BDD, 0, 0);
    sem_init(&IS, 0, 0);
    sem_init(&RC, 0, 0);
    sem_init(&IA, 0, 0);
    sem_init(&AA, 0, 0);
    sem_init(&CG, 0, 0);
    sem_init(&RO, 0, 0);
    sem_init(&SO, 0, 0);
    sem_init(&SI, 0, 0);
    sem_init(&DW, 0, 0);
    sem_init(&SD, 0, 0);
    sem_init(&BD, 0, 0);
    sem_init(&CS, 0, 0);

    // Creacion hilos
    pthread_t hIP, hM1, hF1, hED, hM2, hF2, hPA, hBDD, hIS, hRC, hIA, hAA, hCG, hRO, hSO, hSI, hDW, hSD, hBD, hCS;
    pthread_attr_t attr;
    pthread_attr_init(&attr);

    // Llamada a hilos
    pthread_create(&hIP, &attr, pIP, NULL);
    pthread_create(&hM1, &attr, pM1, NULL);
    pthread_create(&hF1, &attr, pF1, NULL);
    pthread_create(&hED, &attr, pED, NULL);
    pthread_create(&hM2, &attr, pM2, NULL);
    pthread_create(&hF2, &attr, pF2, NULL);
    pthread_create(&hPA, &attr, pPA, NULL);
    pthread_create(&hBDD, &attr, pBDD, NULL);
    pthread_create(&hIS, &attr, pIS, NULL);
    pthread_create(&hRC, &attr, pRC, NULL);
    pthread_create(&hIA, &attr, pIA, NULL);
    pthread_create(&hAA, &attr, pAA, NULL);
    pthread_create(&hCG, &attr, pCG, NULL);
    pthread_create(&hRO, &attr, pRO, NULL);
    pthread_create(&hSO, &attr, pSO, NULL);
    pthread_create(&hSI, &attr, pSI, NULL);
    pthread_create(&hDW, &attr, pDW, NULL);
    pthread_create(&hSD, &attr, pSD, NULL);
    pthread_create(&hBD, &attr, pBD, NULL);
    pthread_create(&hCS, &attr, pCS, NULL);

    // Esperar finalizacion hilos
    pthread_join(hIP, NULL);
    pthread_join(hM1, NULL);
    pthread_join(hF1, NULL);
    pthread_join(hED, NULL);
    pthread_join(hM2, NULL);
    pthread_join(hF2, NULL);
    pthread_join(hPA, NULL);
    pthread_join(hBDD, NULL);
    pthread_join(hIS, NULL);
    pthread_join(hRC, NULL);
    pthread_join(hIA, NULL);
    pthread_join(hAA, NULL);
    pthread_join(hCG, NULL);
    pthread_join(hRO, NULL);
    pthread_join(hSO, NULL);
    pthread_join(hSI, NULL);
    pthread_join(hDW, NULL);
    pthread_join(hSD, NULL);
    pthread_join(hBD, NULL);
    pthread_join(hCS, NULL);

    return 0;
}
