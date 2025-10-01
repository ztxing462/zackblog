export interface CatImage {
  image: string | { src: string }
}

export const cats: CatImage[] = [
  {
    image: '/images/wormhole.png'
  },
  {
    image: '/images/social-card.png'
  },
  {
    image: {
      src: '/images/social-card-1.png'
    }
  }
]