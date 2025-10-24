# Étape 1 : Utiliser l'image Node.js
FROM node:18-alpine

# Étape 2 : Créer le répertoire de l’app
WORKDIR /app

# Étape 3 : Copier les fichiers et installer les dépendances
COPY package*.json ./
RUN npm install

# Étape 4 : Copier le code source
COPY . .

# Étape 5 : Exposer le port 80
EXPOSE 80

# Étape 6 : Lancer l’app
CMD ["npm", "start"]
