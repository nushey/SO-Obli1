#include <stdio.h>
#include <semaphore.h>
#include <pthread.h>

sem_t ED, M2, F2, PA, BDD, IS, RC, IA, AA, CG, RO, SO, SI, DW, SD, BD, CS;
pthread_mutex_t mutex_PA, mutex_RC, mutex_IA, mutex_AA, mutex_CG, mutex_RO, mutex_SO, mutex_SI, mutex_DW, mutex_SD, mutex_BD, mutex_CS;
int countPA, countIA, countAA, countCG, countRO, countRC, countSO, countSD, countBD, countCS, countSI, countDW = 0;

void print(char x[])
{
    printf("Materia: %s\n", x);
}

void *pIP(void *x)
{
    print("IP");
    sem_post(&ED);
}

void *pM1(void *x)
{
    print("M1");
    sem_post(&M2);
}
void *pF1(void *x)
{
    print("F1");
    sem_post(&F2);
}

void *pED(void *x)
{
    sem_wait(&ED);
    print("ED");
    sem_post(&BDD);
    pthread_mutex_lock(&mutex_PA);
    countPA++;
    if (countPA == 2)
        sem_post(&PA);
    pthread_mutex_unlock(&mutex_PA);
}

void *pM2(void *x)
{
    sem_wait(&M2);
    print("M2");
    // PA
    pthread_mutex_lock(&mutex_PA);
    countPA++;
    if (countPA == 2)
        sem_post(&PA);
    pthread_mutex_unlock(&mutex_PA);
    // IA
    pthread_mutex_lock(&mutex_IA);
    countIA++;
    if (countIA == 2)
        sem_post(&IA);
    pthread_mutex_unlock(&mutex_IA);
    // AA
    pthread_mutex_lock(&mutex_AA);
    countAA++;
    if (countAA == 2)
        sem_post(&AA);
    pthread_mutex_unlock(&mutex_AA);
    // BD
    pthread_mutex_lock(&mutex_BD);
    countBD++;
    if (countBD == 2)
        sem_post(&BD);
    pthread_mutex_unlock(&mutex_BD);
}

void *pF2(void *x)
{
    sem_wait(&F2);
    print("F2");
    // RC
    pthread_mutex_lock(&mutex_RC);
    countRC++;
    if (countRC == 2)
        sem_post(&RC);
    pthread_mutex_unlock(&mutex_RC);
    // CG
    pthread_mutex_lock(&mutex_CG);
    countCG++;
    if (countCG == 2)
        sem_post(&CG);
    pthread_mutex_unlock(&mutex_CG);
    // RO
    pthread_mutex_lock(&mutex_RO);
    countRO++;
    if (countRO == 2)
        sem_post(&RO);
    pthread_mutex_unlock(&mutex_RO);
}

void *pPA(void *x)
{
    sem_wait(&PA);
    print("PA");
    sem_post(&IS);
    // SO
    pthread_mutex_lock(&mutex_SO);
    countSO++;
    if (countSO == 2)
        sem_post(&SO);
    pthread_mutex_unlock(&mutex_SO);
    // RC
    pthread_mutex_lock(&mutex_RC);
    countRC++;
    if (countRC == 2)
        sem_post(&RC);
    pthread_mutex_unlock(&mutex_RC);
    // AA
    pthread_mutex_lock(&mutex_AA);
    countAA++;
    if (countAA == 2)
        sem_post(&AA);
    pthread_mutex_unlock(&mutex_AA);
    // IA
    pthread_mutex_lock(&mutex_IA);
    countIA++;
    if (countIA == 2)
        sem_post(&IA);
    pthread_mutex_unlock(&mutex_IA);
    // RO
    pthread_mutex_lock(&mutex_RO);
    countRO++;
    if (countRO == 2)
        sem_post(&RO);
    pthread_mutex_unlock(&mutex_RO);
    // CG
    pthread_mutex_lock(&mutex_CG);
    countCG++;
    if (countCG == 2)
        sem_post(&CG);
    pthread_mutex_unlock(&mutex_CG);
}

void *pBDD(void *x)
{
    sem_wait(&BDD);
    print("BDD");
    // SI
    pthread_mutex_lock(&mutex_SI);
    countSI++;
    if (countSI == 2)
        sem_post(&SI);
    pthread_mutex_unlock(&mutex_SI);
    // DW
    pthread_mutex_lock(&mutex_DW);
    countDW++;
    if (countDW == 2)
        sem_post(&DW);
    pthread_mutex_unlock(&mutex_DW);
    // BD
    pthread_mutex_lock(&mutex_BD);
    countBD++;
    if (countBD == 2)
        sem_post(&BD);
    pthread_mutex_unlock(&mutex_BD);
}

void *pRC(void *x)
{
    sem_wait(&RC);
    print("RC");
    // SO
    pthread_mutex_lock(&mutex_SO);
    countSO++;
    if (countSO == 2)
        sem_post(&SO);
    pthread_mutex_unlock(&mutex_SO);
    // SD
    pthread_mutex_lock(&mutex_SD);
    countSD++;
    if (countSD == 2)
        sem_post(&SD);
    pthread_mutex_unlock(&mutex_SD);
    // DW
    pthread_mutex_lock(&mutex_DW);
    countDW++;
    if (countDW == 2)
        sem_post(&DW);
    pthread_mutex_unlock(&mutex_DW);
    // SI
    pthread_mutex_lock(&mutex_SI);
    countSI++;
    if (countSI == 2)
        sem_post(&SI);
    pthread_mutex_unlock(&mutex_SI);
}

void *pIS(void *x)
{
    sem_wait(&IS);
    print("IS");
}
void *pIA(void *x)
{
    sem_wait(&IA);
    print("IA");
}
void *pAA(void *x)
{
    sem_wait(&AA);
    print("AA");
}
void *pCG(void *x)
{
    sem_wait(&CG);
    print("CG");
}
void *pRO(void *x)
{
    sem_wait(&RO);
    print("RO");
}

void *pSO(void *x)
{
    sem_wait(&SO);
    print("SO");
    // CS
    pthread_mutex_lock(&mutex_CS);
    countCS++;
    if (countCS == 2)
        sem_post(&CS);
    pthread_mutex_unlock(&mutex_CS);
    // SD
    pthread_mutex_lock(&mutex_SD);
    countSD++;
    if (countSD == 2)
        sem_post(&SD);
    pthread_mutex_unlock(&mutex_SD);
}

void *pSI(void *x)
{
    sem_wait(&SI);
    print("SI");
    // CS
    pthread_mutex_lock(&mutex_CS);
    countCS++;
    if (countCS == 2)
        sem_post(&CS);
    pthread_mutex_unlock(&mutex_CS);
}
void *pDW(void *x)
{
    sem_wait(&DW);
    print("DW");
}

void *pSD(void *x)
{
    sem_wait(&SD);
    print("SD");
}

void *pBD(void *x)
{
    sem_wait(&BD);
    print("BD");
}

void *pCS(void *x)
{
    sem_wait(&CS);
    print("CS");
}

int main()
{

    // Inicializacion semaforos
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