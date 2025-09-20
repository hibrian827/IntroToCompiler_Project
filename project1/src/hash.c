/*
 * File Name    : hash.c
 * Description  : An implementation file for the hash table.
 * 
 * Course       : Introduction to Compilers
 * Dept. of Electrical and Computer Engineering, Seoul National University
 */

#include "subc.h"

#define  HASH_TABLE_SIZE   101

typedef struct nlist {
  struct nlist *next;
  id *data;
} nlist;

static nlist *hashTable[HASH_TABLE_SIZE];

unsigned hash(char *s) {
    unsigned hashval = 0;
    for (int i = 0; s[i] != '\0'; i++) {
        hashval = s[i] + 31 * hashval;
    }
    return hashval % HASH_TABLE_SIZE;
}

id *enter(int tokenType, char *name, int length) {
  unsigned index = hash(name);
  nlist *np;

  // Search the table
  for (np = hashTable[index]; np != NULL; np = np->next) {
    if (strncmp(name, np->data->name, length) == 0 && np->data->name[length] == '\0') {
      np->data->count++;
      return np->data;
    }
  }

  // Not found -> create new entry
  np = (nlist *)malloc(sizeof(*np));
  if (np == NULL) return NULL;

  id *newId = (id *)malloc(sizeof(*newId));
  if (newId == NULL) {
    free(np);
    return NULL;
  }

  newId->tokenType = tokenType;
  newId->count = 1;
  newId->name = (char *)malloc(length + 1);
  if (newId->name == NULL) {
    free(newId);
    free(np);
    return NULL;
  }
  strncpy(newId->name, name, length);
  newId->name[length] = '\0';

  np->data = newId;
  np->next = hashTable[index];
  hashTable[index] = np;

  return newId;
}
