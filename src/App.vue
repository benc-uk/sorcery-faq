<template>
  <div>
    <div class="head">
      <h1>Sorcery TCG: Mobile FAQ</h1>
    </div>

    <div class="toolbar">
      <select v-model="selectedCard">
        <option value="">-- Select a card --</option>
        <option v-for="card, id of cards" :key="id" :value="id">
          {{ card.name }}
        </option>
      </select>
    </div>

    <div v-if="error" class="error">{{ error }}</div>

    <div v-if="selectedCard" class="result">
      <img :src="cards[selectedCard].image" :alt="cards[selectedCard].name" class="card-img" />

      <div v-for="question of matchedQuestions" :key="question.id">
        <div class=" question">Q: {{ question.question }}</div>
        <div class="answer" v-html="question.answer"></div>
      </div>
    </div>

  </div>
</template>

<script>
const FAQ_JSON_URL = 'data.json';
const IMAGE_BASE_URL = 'https://d27a44hjr9gen3.cloudfront.net/alp/';

export default {
  name: 'App',

  data() {
    return {
      // Base data
      cards: {},
      questions: [],

      // State
      error: null,
      selectedCard: '',
      matchedQuestions: [],
    };
  },

  async mounted() {
    await this.fetchCards();
  },

  watch: {
    selectedCard() {
      // find the questions that match the selected card
      this.matchedQuestions = this.questions.filter(question => {

        for (const card of question.cards) {
          if (card.id === this.selectedCard) {
            return true;
          }
        }
      });

    },
  },

  methods: {
    async fetchCards() {
      try {
        const response = await fetch(FAQ_JSON_URL);

        if (response.ok && response.status === 200) {
          try {
            const faqJson = await response.json();
            for (const question of faqJson.result.data.json) {
              for (const card of question.cards) {
                this.cards[card.id] = {
                  name: card.name,
                  image: IMAGE_BASE_URL + card.slug + '.png',
                }
              }

              this.questions.push(question);
            }

            // Sort cards by name
            this.cards = Object.fromEntries(
              Object.entries(this.cards).sort(([, a], [, b]) => a.name.localeCompare(b.name))
            );
          } catch (e) {
            this.error = 'Unable to parse JSON: ' + e;
          }
        } else {
          this.error = 'Unable to fetch FAQ JSON, status: ' + response.status + ' ' + response.statusText;
        }
      } catch (e) {
        this.error = e;
      }
    }
  }
}


</script>



<style scoped></style>
