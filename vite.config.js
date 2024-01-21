import { defineConfig } from "vite";
import vue from "@vitejs/plugin-vue";

const isProd = process.env.NODE_ENV === "production";
// https://vitejs.dev/config/
export default defineConfig({
  plugins: [vue()],
  base: isProd ? "/sorcery-faq/" : "/",
});
