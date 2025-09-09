import { 
  ContainerRegistrationKeys,
  Modules
} from "@medusajs/framework/utils"
import {
  createApiKeysWorkflow,
  createSalesChannelsWorkflow,
  linkSalesChannelsToApiKeyWorkflow
} from "@medusajs/medusa/core-flows"

export default async function createPublishableKey({ container }) {
  const logger = container.resolve(ContainerRegistrationKeys.LOGGER)
  const salesChannelModuleService = container.resolve(Modules.SALES_CHANNEL)

  try {
    // Check for existing sales channel
    let defaultSalesChannel = await salesChannelModuleService.listSalesChannels({
      name: "Default Sales Channel",
    })

    if (!defaultSalesChannel.length) {
      // Create the default sales channel
      const { result: salesChannelResult } = await createSalesChannelsWorkflow(
        container
      ).run({
        input: {
          salesChannelsData: [
            {
              name: "Default Sales Channel",
              description: "Default sales channel for storefront"
            },
          ],
        },
      })
      defaultSalesChannel = salesChannelResult
      logger.info(`Created sales channel: ${defaultSalesChannel[0].id}`)
    } else {
      logger.info(`Using existing sales channel: ${defaultSalesChannel[0].id}`)
    }

    // Create publishable API key
    const { result: publishableApiKeyResult } = await createApiKeysWorkflow(
      container
    ).run({
      input: {
        api_keys: [
          {
            title: "Storefront API Key",
            type: "publishable",
            created_by: "",
          },
        ],
      },
    })
    const publishableApiKey = publishableApiKeyResult[0]

    // Link sales channel to API key
    await linkSalesChannelsToApiKeyWorkflow(container).run({
      input: {
        id: publishableApiKey.id,
        add: [defaultSalesChannel[0].id],
      },
    })

    logger.info("✅ Publishable API Key created successfully!")
    logger.info(`📝 API Key ID: ${publishableApiKey.id}`)
    logger.info(`🔑 API Key Token: ${publishableApiKey.token}`)
    logger.info(`🛍️  Sales Channel: ${defaultSalesChannel[0].name}`)
    logger.info("\n👉 Add this to your storefront .env.local:")
    logger.info(`NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY=${publishableApiKey.token}`)
    
  } catch (error) {
    logger.error("Failed to create publishable key:", error)
    process.exit(1)
  }
}