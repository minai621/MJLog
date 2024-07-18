'use client'

import siteMetadata from '@/data/siteMetadata'
import { Comments as CommentsComponent } from 'pliny/comments'
import { useState } from 'react'

export default function Comments({ slug }: { slug: string }) {
  const [loadComments, setLoadComments] = useState(false)

  if (!siteMetadata.comments?.provider) {
    return null
  }
  return (
    <>
      <CommentsComponent commentsConfig={siteMetadata.comments} slug={slug} />
    </>
  )
}
